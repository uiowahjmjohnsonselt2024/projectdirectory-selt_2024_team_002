# frozen_string_literal: true

# The world that a user can join, including functions to initialize and
# update/retrieve information from a displayed grid.
require 'net/http'
require 'json'

# represents the model class for the worlds object
class World < ApplicationRecord
  has_many :gridsquares, dependent: :destroy
  @@dim = 6 # rubocop:disable Style/ClassVars

  # this must be done this way, active stroage DOES NOT WORK
  # with after_create call back when seeding!!!!!!!
  def init_if_not_inited
    return unless gridsquares.empty?

    initialize_grid
  end

  def self.dim
    @@dim
  end

  # def load_from_s3
  #   s3 = Aws::S3::Client.new
  #   obj = s3.get_object(bucket: ENV['S3_BUCKET_NAME'], key: "worlds/#{id}.json")
  #   JSON.parse(obj.body.read)
  # rescue Aws::S3::Errors::NoSuchKey
  #   nil
  # end

  private

  def create_square(row, col)
    text_prompt = generate_text_description(row, col)
    uri = generate_image_ai(text_prompt)
    download_and_attach_image(uri, row, col)
  end

  def build_headers
    { 'Content-Type' => 'application/json', 'Authorization' => "Bearer #{ENV['OPENAI_API_KEY']}" }
  end

  def build_body(row, col)
    {
      model: 'gpt-3.5-turbo',
      messages: [
        { role: 'system',
          content: 'Pick a random environment/biome/area that would make sense to be in
                     an area in a video game. Return the environment as one word.' },
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

    begin
      result = JSON.parse(response.body)
      res = result.dig('choices', 0, 'message', 'content')&.strip
      Rails.logger.info("got 3.5 turbo response for row: #{row}, col: #{col}, response: #{res}")
      res
    rescue JSON::ParserError => e
      Rails.logger.info "Failed to parse JSON: #{e.message}"
      nil
    end
  end

  def build_dalle_body(text)
    {
      prompt: text,
      n: 1,
      size: '256x256'
    }.to_json
  end

  # given the prompt text, return an URI that reperesents
  def generate_image_ai(prompt)
    dalle_uri = URI('https://api.openai.com/v1/images/generations')
    headers = build_headers
    dalle_body = build_dalle_body(prompt)

    response = make_http_request(dalle_uri, headers, dalle_body)
    unless (200..299).include?(response.code.to_i)
      logstr = "call to GPT 3.5 failed with http status code: #{response.code.to_i}, error: #{response.body}"
      Rails.logger.error(logstr)
      return
    end

    begin
      result = JSON.parse(response.body)
      res = result.dig('data', 0, 'url')
      Rails.logger.info("got dalle image url, url: #{res}")
      res
    rescue JSON::ParserError => e
      Rails.logger.info "Failed to parse JSON: #{e.message}"
      nil
    end
  end

  def download_and_attach_image(image_uri, row, col)
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
    gridsquare = gridsquares.where(row: row, col: col).first
    gridsquare.image.attach(new_image)
  end

  def initialize_grid
    (1..@@dim).each do |row|
      (1..@@dim).each do |col|
        gridsquares.create!(row: row, col: col)
      end
    end
    create_square(1, 1) # only these squares or we get rate limited.
    create_square(2, 1)
    create_square(2, 2)
    create_square(1, 2)
  end
end
