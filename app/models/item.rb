# frozen_string_literal: true

# Class that represents an item
class Item < ApplicationRecord
  has_many :inventory_items, dependent: :destroy
  has_many :user_worlds, through: :inventory_items
end
