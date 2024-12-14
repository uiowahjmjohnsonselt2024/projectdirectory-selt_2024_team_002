RSpec.describe Gridsquare, type: :model do
  describe 'validate' do
    it 'is not valid when row is missing' do
      event = described_class.new(col: 4)
      expect(event).not_to be_valid
    end

    it 'is not valid when col is missing' do
      event = described_class.new(row: 4)
      expect(event).not_to be_valid
    end

    it 'is valid when row col present' do
      event = described_class.new(row: 4, col: 4)
      expect(event).to be_valid
    end
  end

  describe 'set_random_buy_in_amount' do
    it 'sets buy in amount to multiples of 5' do
      event = described_class.new
      event.set_random_buy_in_amount
      expect(event.buy_in_amount % 5).to eq(0)
    end
  end
end