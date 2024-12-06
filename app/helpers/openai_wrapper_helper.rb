# frozen_string_literal: true

# wrapper module for all OPENAI calls. we are not unit testing this file, as 
# all it does is orchastrate api calls to openai  
module OpenaiWrapperHelper
  @@dim = World.dim

  class << self
    def create_square(row, col, world)
      # calls to openai, generates an image and attatches it.
      text_prompt = generate_text_description(row, col)
      return unless text_prompt

      uri = generate_image_ai(text_prompt)
      download_and_attach_image(uri, row, col, world, text_prompt)
    end

    private

    def build_headers
      { 'Content-Type' => 'application/json', 'Authorization' => "Bearer #{ENV['OPENAI_API_KEY']}" }
    end

    def build_body(row, col)
      {
        model: 'gpt-3.5-turbo',
        messages: [
          { role: 'system',
            content: 'Pick a random environment/biome/area that would make sense to be in an area in a video game. Return the environment as one word.' },
          { role: 'user', content: "Player entered cell (#{row}, #{col})" }
        ],
        max_tokens: 10
      }.to_json
    end

    def make_http_request(uri, headers, body)
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      request = Net::HTTP::Post.new(uri.path, headers)
      request.body = body
      http.request(request)
    end

    def generate_text_description(row, col)
      uri = URI('https://api.openai.com/v1/chat/completions')
      headers = build_headers
      body = build_body(row, col)

      response = make_http_request(uri, headers, body)
      unless (200..299).include?(response.code.to_i)
        logstr = "call to GPT 3.5 failed with http status code: #{response.code.to_i}, error: #{response.body}"
        Rails.logger.error(logstr)
        return
      end

      result = JSON.parse(response.body)
      res = result.dig('choices', 0, 'message', 'content')&.strip
      Rails.logger.info("got 3.5 turbo response for row: #{row}, col: #{col}, response: #{res}")
      res
    end

    def build_dalle_body(text)
      {
        prompt: "#{text} in minimalist style",
        n: 1,
        size: '256x256'
      }.to_json
    end

    def generate_image_ai(prompt)
      dalle_uri = URI('https://api.openai.com/v1/images/generations')
      headers = build_headers
      dalle_body = build_dalle_body(prompt)

      response = make_http_request(dalle_uri, headers, dalle_body)
      unless (200..299).include?(response.code.to_i)
        logstr = "call to DALL-E failed with http status code: #{response.code.to_i}, error: #{response.body}"
        Rails.logger.error(logstr)
        return
      end

      result = JSON.parse(response.body)
      res = result.dig('data', 0, 'url')
      Rails.logger.info("got dalle image url, url: #{res}")
      res
    end

    # rubocop: disable Metrics/MethodLength
    def download_and_attach_image(image_uri, row, col, world, description)
      image_response = Net::HTTP.get_response(URI(image_uri))
      unless (200..299).include?(image_response.code.to_i)
        logstr = "Call to DALL-E failed with HTTP status code: #{image_response.code.to_i}, error: #{image_response.body}"
        Rails.logger.error(logstr)
        return
      end

      new_image = {
        io: StringIO.new(image_response.body),
        filename: "#{row}_#{col}_generated.png",
        content_type: 'image/png'
      }

      Rails.logger.info("Received DALL-E image for row #{row}, col #{col}")

      # This will attach the image and upload it to either S3 (production) or disk (development/test)
      gridsquare = world.gridsquares.where(row: row, col: col).first
      gridsquare.image.attach(new_image)
      gridsquare.update(description: description)
    end
    # rubocop: enable Metrics/MethodLength
  end
end
