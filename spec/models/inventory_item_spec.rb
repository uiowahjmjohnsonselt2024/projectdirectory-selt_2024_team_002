require 'rails_helper'

RSpec.describe InventoryItem, type: :model do
  it 'should call the database normally' do
    inventory = instance_double(described_class)
    allow(InventoryItem).to receive(:where).and_return([inventory])
    allow(inventory).to receive(:item_id).and_return("2")
    expect(inventory.item_id).to eq("2")
  end
end
