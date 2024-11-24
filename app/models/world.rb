# frozen_string_literal: true

# The world that a user can join, including functions to initialize and
# update/retrieve information from a displayed grid.
require 'net/http'
require 'json'

# represents the model class for the worlds object
class World < ActiveRecord::Base
  has_one :grid, dependent: :destroy
  has_many :users
  has_many :gridsquares
  after_save :initialize_grid
  @@dim = 6

  def initialize_grid(rows = 6, cols = 6, default_value = '0')
    (1..@@dim).each do |row|
      (1..@@dim).each do |col|
        self.gridsquares.create!(row:row, col:col)
      end
    end
    path = Rails.root.join('db', 'shreck.png') # good
    self.gridsquares.where(row: 1, col: 1).first.image.attach(path)
  end

  def get_grids()
    self.gridsquares
  end

  def set(row, col, value)
    data[row][col] = value
    save
  end

  def get(row, col)
    data[row][col]
  rescue StandardError
    nil
  end

  def display
    data.each do |row|
    end
  end

  # def load_from_s3
  #   s3 = Aws::S3::Client.new
  #   obj = s3.get_object(bucket: ENV['S3_BUCKET_NAME'], key: "worlds/#{id}.json")
  #   JSON.parse(obj.body.read)
  # rescue Aws::S3::Errors::NoSuchKey
  #   nil
  # end

  def enter_cell(_row, _col)
    nil # skipping this
    # URI('https://api.openai.com/v1/chat/completions')
    # headers = {
    #   'Content-Type' => 'application/json',
    #   'Authorization' => "Bearer #{ENV['OPENAI_API_KEY']}"
    # }
    # body = {
    #   model: 'gpt-3.5-turbo',
    #   messages: [
    #     { role: 'system', content: 'You are a night of the realm, seeking a dangerous beast to prove yourself.' },
    #     { role: 'user', content: "Player entered cell (#{row}, #{col})" }
    #   ],
    #   max_tokens: 5
    # }.to_json

    # http = Net::HTTP.new(uri.host, uri.port)
    # http.use_ssl = true
    # request = Net::HTTP::Post.new(uri.path, headers)
    # request.body = body

    # response = http.request(request)

    # if response.code.to_i != 200
    #   puts "Call to OpenAI failed with status code #{response.code.to_i}: #{response.body}"
    #   return
    # end

    # result = JSON.parse(response.body)
    # if result['choices'] && result['choices'][0]
    #   text = result['choices'][0]['message']['content']
    #   # set(row, col, text)
    #   puts(text)
    # else
    #   puts("Unexpected response from OpenAI: #{response.body}")
    # end
  end
end
