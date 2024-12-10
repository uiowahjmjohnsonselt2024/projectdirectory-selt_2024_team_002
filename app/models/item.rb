# frozen_string_literal: true

# Class that represents an item
class Item < ApplicationRecord
  has_many :shop_items, dependent: :destroy
  has_many :shops, through: :shop_items
  has_many :inventory_items, dependent: :destroy
  has_many :user_worlds, through: :inventory_items
end
