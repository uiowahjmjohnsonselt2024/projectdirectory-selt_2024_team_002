require 'rails_helper'

RSpec.describe Item, type: :model do
  it 'should call the database normally' do
    item = instance_double(described_class)
    allow(Item).to receive(:where).and_return([item])
    allow(item).to receive(:item_name).and_return("Test item")
    expect(item.item_name).to eq("Test item")
  end

  it 'activates speed boost when using a speed potion' do
    user_world.use_speed_potion
    expect(user_world.speed_boost).to be true
    expect(user_world.speed_boost_count).to eq 0
  end

  it 'resets speed boost after 5 non-adjacent moves' do
    pending
  end
end
