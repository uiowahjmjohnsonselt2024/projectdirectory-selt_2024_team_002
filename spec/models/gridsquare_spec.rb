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
end