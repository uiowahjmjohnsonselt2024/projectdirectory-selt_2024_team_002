# frozen_string_literal: true

# Model dealing with one grid
class Gridsquare < ApplicationRecord
  belongs_to :world
  validates :row, presence: true
  validates :col, presence: true
  has_one_attached :image

  def self.find_by_row_col(world, row, col)
    Gridsquare.where(world: world, row: row, col: col).first
  end

  def set_random_buy_in_amount
    # set buy in to rand multiples of 5
    self.buy_in_amount = rand(1..20) * 5
  end
end
