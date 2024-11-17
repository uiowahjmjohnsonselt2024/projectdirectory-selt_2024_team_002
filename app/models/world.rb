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
      puts row.join(' ')
    end
  end
end
