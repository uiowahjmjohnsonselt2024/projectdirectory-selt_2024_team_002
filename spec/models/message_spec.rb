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
  describe 'get messages for world' do 
    it 'performs the necessary query' do
      where = double('where')
      order = double('order')
      allow(Message).to receive(:where).and_return(where)
      allow(where).to receive(:order).and_return(order)
      expect(order).to receive(:limit)
      described_class.get_messages_for_world(2)
    end
  end
end