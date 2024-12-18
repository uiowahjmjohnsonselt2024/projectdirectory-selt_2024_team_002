# frozen_string_literal: true

# class that represent an item belonging to a user in a world
class InventoryItem < ApplicationRecord
  belongs_to :user_world
  belongs_to :item

  validates :amount_available, numericality: { greater_than_or_equal_to: 0 }
  validates :user_world_id, presence: true
  validates :item_id, presence: true

  # rubocop:disable Metrics/MethodLength
  def consume_item
    case item.item_name
    when 'XP Boost'
      user_world.boost_xp
    when 'Speed Potion'
      user_world.use_speed_potion
    when '4 Leaf Clover'
      user_world.use_leaf_clover
    else
      flash[:alert] = 'Item not found'
    end
    amount_available > 1 ? decrement(:amount_available, 1) : destroy
    save
    item.item_name
  end
  # rubocop:enable Metrics/MethodLength
end
