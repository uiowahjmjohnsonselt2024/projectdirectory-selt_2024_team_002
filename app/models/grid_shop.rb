# frozen_string_literal: true

# Model to represent relationship between a grid square and a shop
class GridShop < ApplicationRecord
  belongs_to :gridsquare
  belongs_to :shop
end
