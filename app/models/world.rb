# frozen_string_literal: true

# The world that a user can join, including functions to initialize and
# update/retrieve information from a displayed grid.
class World < ActiveRecord::Base
  has_one :grid, dependent: :destroy
  has_many :users

  serialize :data, Array

  def initialize_grid(rows = 6, cols = 6, default_value = '0')
    self.data = Array.new(rows) { Array.new(cols, default_value) }
    set(2, 3, '1') # Temporarily fill a grid tile
    save
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

  def load_from_s3
    s3 = Aws::S3::Client.new
    obj = s3.get_object(bucket: ENV['S3_BUCKET_NAME'], key: "worlds/#{id}.json")
    JSON.parse(obj.body.read)
  rescue Aws::S3::Errors::NoSuchKey
    nil
  end
end
