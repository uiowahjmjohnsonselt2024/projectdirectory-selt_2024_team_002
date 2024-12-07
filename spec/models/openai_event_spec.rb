RSpec.describe OpenaiEvent, type: :model do
  describe 'validate' do
    it 'is not valid when row is out of bounds' do
      event = described_class.new(row: 0, col: 4)
      expect(event).not_to be_valid
    end

    it 'is not valid when col is out of bounds' do
      event = described_class.new(row: 4, col: 0)
      expect(event).not_to be_valid
    end

    it 'is valid when row col in bounds' do
      event = described_class.new(row: 4, col: 4)
      expect(event).not_to be_valid
    end
  end
end
