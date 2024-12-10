# frozen_string_literal: true

# class that represent an item belonging to a user in a world
class InventoryItem < ApplicationRecord
  belongs_to :user_world
  belongs_to :item

  validates :amount_available, uniqueness: true
end
