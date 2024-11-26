# frozen_string_literal: true

# The world that a user can join, including functions to initialize and
# update/retrieve information from a displayed grid.
require 'net/http'
require 'json'
require 'aws-sdk-s3'

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

  def load_images_from_s3
    s3 = Aws::S3::Client.new(region: ENV['AWS_Region'])
    @gridsquares = gridsquares.all

    @gridsquares.each do |gridsquare|
      image_url = get_image_from_s3(s3, gridsquare)
      gridsquare.update(image_url: image_url) if image_url
    end
  end

  def get_image_from_s3(s3, gridsquare)
    bucket_name = ENV['S3_BUCKET_NAME']
    key = "worlds/#{id}/grid_#{gridsquare.row}_#{gridsquare.col}.png"

    begin
      # Check if the object exists in the bucket
      s3.head_object(bucket: bucket_name, key: key)
      # Return the public URL
      "https://#{bucket_name}.s3.amazonaws.com/#{key}"
    rescue Aws::S3::Errors::NoSuchKey, Aws::S3::Errors::NotFound
      Rails.logger.warn("S3 object not found: bucket=#{bucket_name}, key=#{key}")
      nil # No image found for the grid square
    end
  end

  def generate_cell(_row, _col)
    # Step 1: Generate text description
    uri = URI('https://api.openai.com/v1/chat/completions')
    headers = { 'Content-Type' => 'application/json', 'Authorization' => "Bearer #{ENV['OPENAI_API_KEY']}" }
    body = {
      model: 'gpt-3.5-turbo',
      messages: [
        { role: 'system',
          content: 'Pick a random environment/biome/area that would make sense to be in an area in a video game. Return the environment as one word.' },
        { role: 'user', content: "Player entered cell (#{_row}, #{_col})" }
      ],
      max_tokens: 10
    }.to_json

    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    request = Net::HTTP::Post.new(uri.path, headers)
    request.body = body

    response = http.request(request)
    if response.code.to_i != 200
      Rails.logger.debug "Call to OpenAI failed with status code #{response.code.to_i}: #{response.body}"
      return
    end

    result = JSON.parse(response.body)
    if result['choices'] && result['choices'][0]
      text = result['choices'][0]['message']['content'].strip
      Rails.logger.debug("Generated text: #{text}")

      # Step 2: Generate image based on the text
      image_uri = generate_image_ai(text)
      Rails.logger.debug("Generated image URI: #{image_uri}")

      # Step 3: Download the image
      image_response = Net::HTTP.get_response(URI(image_uri))
      if image_response.code.to_i == 200
        new_image = {
          io: StringIO.new(image_response.body),
          filename: "#{_row}_#{_col}_generated.png",
          content_type: 'image/png'
        }

        gridsquare = gridsquares.find_or_create_by(row: _row, col: _col)

        # Purge existing image and attach new one to S3
        gridsquare.image.purge if gridsquare.image.attached?
        gridsquare.image.attach(new_image) # ActiveStorage handles the S3 upload

        Rails.logger.debug "Image successfully updated for cell (#{_row}, #{_col})"
      else
        Rails.logger.debug "Failed to download the image: #{image_response.body}"
      end
    else
      Rails.logger.debug "Unexpected response from OpenAI: #{response.body}"
    end
  end

  def generate_image_ai(text)
    dalle_uri = URI('https://api.openai.com/v1/images/generations')
    headers = {
      'Content-Type' => 'application/json',
      'Authorization' => "Bearer #{ENV['OPENAI_API_KEY']}"
    }
    dalle_body = {
      prompt: text,
      n: 1,
      size: '256x256'
    }.to_json

    http = Net::HTTP.new(dalle_uri.host, dalle_uri.port)
    http.use_ssl = true
    request = Net::HTTP::Post.new(dalle_uri.path, headers)
    request.body = dalle_body

    response = http.request(request)

    raise "Call to OpenAI failed with status code #{response.code.to_i}: #{response.body}" if response.code.to_i != 200

    result = JSON.parse(response.body)
    raise "Unexpected response from OpenAI: #{response.body}" unless result['data'] && result['data'][0]

    result['data'][0]['url']
  end

  def initialize_grid
    (1..@@dim).each do |row|
      (1..@@dim).each do |col|
        gridsquares.create!(row: row, col: col)
        # path = Rails.root.join('db/shreck.png')
        # gridsquares.where(row: row, col: col).first.image.attach(io: File.open(path), filename: 'face.jpg',
        #                                                          content_type: 'image/png')
      end
    end
  end
end
