# frozen_string_literal: true

require 'spec_helper'
require 'rails_helper'
require 'app/helpers/shards_helper'

# rubocop:disable Metrics/BlockLength
describe UsersController do
  describe 'When a user is logged in' do
    before(:each) do
      usr = double('User')
      expect(User).to receive(:find_user_by_session_token).and_return(usr)
    end
    describe 'When a user wants to purchase shard' do
      it 'should redirect to purchase shard page' do
        get 'purchase'
        expect(response).to render_template('purchase')
      end
    end
  end
end
# rubocop:enable Metrics/BlockLength
