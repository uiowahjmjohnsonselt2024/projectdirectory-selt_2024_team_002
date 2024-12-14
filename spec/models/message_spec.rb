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

    it 'get all messages' do
      messages = [instance_double('Message', id: 1, user_id: 1, world_id: 1, message: "Hi")]
      allow(Message).to receive(:get_messages_for_world).with(1).and_return(messages)
      allow(Message).to receive(:where).with(world_id: 1).and_return(messages)
      expect(messages[0].message).to eq("Hi")
    end
  end
end