# frozen_string_literal: true

# The world that a user can join, including functions to initialize and
# update/retrieve information from a displayed grid.
require 'net/http'
require 'json'
require 'aws-sdk-s3'

# Helper methods for the World model
module WorldHelper
  def load_images_from_s3
    s3 = Aws::S3::Client.new(region: ENV['AWS_Region'])
    @gridsquares = gridsquares.all

    @gridsquares.each do |gridsquare|
      image_url = get_image_from_s3(s3, gridsquare)
      gridsquare.update(image_url: image_url) if image_url
    end
  end

  def get_image_from_s3(s3_client, gridsquare)
    bucket_name = ENV['S3_BUCKET_NAME']
    key = "worlds/#{id}/grid_#{gridsquare.row}_#{gridsquare.col}.png"

    begin
      s3_client.head_object(bucket: bucket_name, key: key)
      "https://#{bucket_name}.s3.amazonaws.com/#{key}"
    rescue Aws::S3::Errors::NoSuchKey, Aws::S3::Errors::NotFound
      Rails.logger.warn("S3 object not found: bucket=#{bucket_name}, key=#{key}")
      nil
    end
  end
end

# represents the model class for the worlds object
class World < ApplicationRecord
  include WorldHelper

  has_many :gridsquares, dependent: :destroy
  @@dim = 6 # rubocop:disable Style/ClassVars

  def init_if_not_inited
    return unless gridsquares.empty?

    initialize_grid
  end

  def self.dim
    @@dim
  end

  def generate_cell(row, col)
    text = generate_text_description(row, col)
    return unless text

    image_uri = generate_image_ai(text)
    return unless image_uri

    download_and_attach_image(image_uri, row, col)
  end

  def generate_text_description(row, col)
    uri = URI('https://api.openai.com/v1/chat/completions')
    headers = build_headers
    body = build_body(row, col)

    response = make_http_request(uri, headers, body)
    return unless response.code.to_i == 200

    result = JSON.parse(response.body)
    result.dig('choices', 0, 'message', 'content')&.strip
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

  def download_and_attach_image(image_uri, row, col)
    image_response = Net::HTTP.get_response(URI(image_uri))
    return unless image_response.code.to_i == 200

    new_image = {
      io: StringIO.new(image_response.body),
      filename: "#{row}_#{col}_generated.png",
      content_type: 'image/png'
    }

    gridsquare = gridsquares.find_or_create_by(row: row, col: col)
    gridsquare.image.purge if gridsquare.image.attached?
    gridsquare.image.attach(new_image)
  end

  def generate_image_ai(text)
    dalle_uri = URI('https://api.openai.com/v1/images/generations')
    headers = build_headers
    dalle_body = build_dalle_body(text)

    response = make_http_request(dalle_uri, headers, dalle_body)
    return unless response.code.to_i == 200

    result = JSON.parse(response.body)
    result.dig('data', 0, 'url')
  end

  def build_dalle_body(text)
    {
      prompt: text,
      n: 1,
      size: '256x256'
    }.to_json
  end

  def initialize_grid
    (1..@@dim).each do |row|
      (1..@@dim).each do |col|
        gridsquares.create!(row: row, col: col)
      end
    end
  end
end
