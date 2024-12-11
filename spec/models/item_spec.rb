require 'rails_helper'

RSpec.describe Item, type: :model do
  it 'should call the database normally' do
    item = instance_double(described_class)
    allow(Item).to receive(:where).and_return([item])
    allow(item).to receive(:item_name).and_return("Test item")
    expect(item.item_name).to eq("Test item")
  end
end
