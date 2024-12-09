# frozen_string_literal: true

# Class that associates an item with a shop
class ShopItem < ApplicationRecord
  belongs_to :shop
  belongs_to :item
end
