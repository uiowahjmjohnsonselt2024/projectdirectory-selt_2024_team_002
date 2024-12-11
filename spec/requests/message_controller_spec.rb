# frozen_string_literal: true

require 'rails_helper'
require 'spec_helper'

# rubocop:disable Metrics/BlockLength
RSpec.describe 'messages', type: :request do
  describe 'not logged in' do
    it 'redirects correctly if the user is not logged in' do
      get '/messages/get/2'
      expect(response).to redirect_to users_login_path
    end
  end
  
  describe 'logged in' do
    before do 
      usr = instance_double(User)
      allow(User).to receive(:find_user_by_session_token).and_return(usr)
      allow(usr).to receive(:id).and_return(1)
    end
    describe 'send message' do
      it 'returns 400 if no msg' do
        post send_message_path
        expect(response).to have_http_status(400)
      end

      it 'calls create when msg is present' do
        expect(Message).to receive(:create!)
        post send_message_path, params: {world_id: 1, message: 'asdasdasd'}
      end
    end
    describe 'fetch messages' do 
        it 'should render you if you are the message creator' do
          where = double('where')
          order = double('order')
          msg = instance_double(Message)
          expect(Message).to receive(:get_messages_for_world).and_return([msg])
          expect(msg).to receive(:user_id).and_return(1)
          expect(msg).to receive(:message).and_return('hiiiiiii')
          get '/messages/get/2'
          expected_json = [
            { 'display_name' => "You", 'content' => 'hiiiiiii' }
          ]
          expect(response.body).to eq(expected_json.to_json)
        end
      end

      it 'has the name of the message creator if you did not create the message' do 
        where = double('where')
          order = double('order')
          msg = instance_double(Message)
          expect(Message).to receive(:get_messages_for_world).and_return([msg])
          expect(msg).to receive(:user_id).and_return(2).twice
          usrr = instance_double(User)
          expect(usrr).to receive(:display_name).and_return('larry')
          expect(User).to receive(:where).and_return([usrr])
          expect(msg).to receive(:message).and_return('hiiiiiii')
          get '/messages/get/2'
          expected_json = [
            { 'display_name' => "larry", 'content' => 'hiiiiiii' }
          ]
          expect(response.body).to eq(expected_json.to_json)
      end
    end
end
# rubocop:enable RSpec/InstanceVariable
# rubocop:enable Metrics/BlockLength
# rubocop:enable RSpec/ExampleLength
