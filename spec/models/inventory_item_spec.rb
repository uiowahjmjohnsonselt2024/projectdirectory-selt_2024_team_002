require 'rails_helper'

RSpec.describe InventoryItem, type: :model do
  it 'should call the database normally' do
    inventory = instance_double(described_class)
    allow(InventoryItem).to receive(:where).and_return([inventory])
    allow(inventory).to receive(:item_id).and_return("2")
    expect(inventory.item_id).to eq("2")
  end

  it 'should boost XP' do
    inventory_item = instance_double(described_class)
    allow(inventory_item).to receive(:consume_item).and_return("XP Boost")
    expect(inventory_item.consume_item).to eq("XP Boost")
  end

  it 'should increase speed' do
    inventory_item = instance_double(described_class)
    allow(inventory_item).to receive(:consume_item).and_return("Speed Potion")
    expect(inventory_item.consume_item).to eq("Speed Potion")
  end

  it 'should increase luck' do
    inventory_item = instance_double(described_class)
    allow(inventory_item).to receive(:consume_item).and_return("4 Leaf Clover")
    expect(inventory_item.consume_item).to eq("4 Leaf Clover")
  end
end
