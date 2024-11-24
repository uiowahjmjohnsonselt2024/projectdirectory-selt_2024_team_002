# frozen_string_literal: true

# Model dealing with one grid
class Gridsquare < ActiveRecord::Base
  belongs_to :world
  validates :row, presence: true
  validates :col, presence: true
  has_one_attached :image
end
