# frozen_string_literal: true

require 'concurrent'

# Model dealing with one grid
class Gridsquare < ApplicationRecord
  belongs_to :world
  validates :row, presence: true
  validates :col, presence: true
  has_one_attached :image
  has_one :grid_shop, dependent: :destroy
  has_one :shop, through: :grid_shop

  def self.find_by_row_col(world, row, col)
    Gridsquare.where(world: world, row: row, col: col).first
  end
end
