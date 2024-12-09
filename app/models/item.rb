# frozen_string_literal: true

# Class that represents an item
class Item < ApplicationRecord
  has_many :shop_items, dependent: :destroy
  has_many :shops, through: :shop_items
end
