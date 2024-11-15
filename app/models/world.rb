class World < ActiveRecord::Base
  has_one :grid, dependent: :destroy
  has_many :users

  serialize :data, Array

  def initialize_grid(rows = 6, cols = 6, default_value = "0")
    self.data = Array.new(rows) { Array.new(cols, default_value) }
    set(2,3, "1") #Temporarily fill a grid tile
    save
  end

  def set(row, col, value)
    self.data[row][col] = value
    save
  end

  def get(row, col)
    self.data[row][col] rescue nil
  end

  def display
    self.data.each do |row|
      puts row.join(" ")
    end
  end
end
