RSpec.describe Message, type: :model do
  describe 'validate' do
    it 'is not valid when message is missing' do
      event = described_class.new()
      expect(event).not_to be_valid
    end

    it 'is valid when message present' do
      event = described_class.new(message: 'hi')
      expect(event).to be_valid
    end
  end
end