# frozen_string_literal: true

require 'rails_helper'

RSpec.describe InventoryItem, type: :model do
  let(:user) { User.create!(display_name: 'Test User', email: 'test@test.com', password: 'Password123!') }
  let(:world) { World.create!(world_name: 'Test World', current_players: 0) }
  let(:user_world) { UserWorld.create!(user: user, world: world) }
  let(:item) { Item.create!(item_name: 'XP Boost') }
  let(:inventory_item) { described_class.new(user_world: user_world, item: item, amount_available: 2) }

  before do
    allow(user_world).to receive(:boost_xp)
    allow(user_world).to receive(:use_speed_potion)
    allow(user_world).to receive(:use_leaf_clover)
    allow(inventory_item).to receive(:save).and_return(true)
  end

  describe 'consume_item' do
    it 'should boost XP' do
      expect(user_world).to receive(:boost_xp)
      expect(inventory_item.consume_item).to eq('XP Boost')
      expect(inventory_item.amount_available).to eq(1)
    end

    it 'should increase speed' do
      item.update(item_name: 'Speed Potion')
      expect(user_world).to receive(:use_speed_potion)
      expect(inventory_item.consume_item).to eq('Speed Potion')
      expect(inventory_item.amount_available).to eq(1)
    end

    it 'should increase luck' do
      item.update(item_name: '4 Leaf Clover')
      expect(user_world).to receive(:use_leaf_clover)
      expect(inventory_item.consume_item).to eq('4 Leaf Clover')
      expect(inventory_item.amount_available).to eq(1)
    end

    it 'should destroy item when amount is 1' do
      inventory_item.update(amount_available: 1)
      expect(inventory_item).to receive(:destroy)
      expect(inventory_item.consume_item).to eq('XP Boost')
    end
  end
end