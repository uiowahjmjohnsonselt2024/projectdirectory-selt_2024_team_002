# frozen_string_literal: true

# Class that represents a shop
class Shop < ApplicationRecord
  has_many :shop_items, dependent: :destroy
  has_many :items, through: :shop_items
end
