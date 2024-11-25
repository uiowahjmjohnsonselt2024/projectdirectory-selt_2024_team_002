# frozen_string_literal: true

require 'spec_helper'
require 'rails_helper'

# rubocop:disable Metrics/BlockLength
describe WorldsController do
  describe 'When a user is logged in' do
    before(:each) do
      usr = double('User')
      expect(User).to receive(:find_user_by_session_token).and_return(usr)
      allow(usr).to receive(:display_name).and_return('')
    end
    describe 'world page' do
      it 'should render the world page' do
        get worlds_path

        expect(response).to render_template('index')
      end
    end
    describe 'adding world' do
      it 'should select the Creating World template for rendering' do
        get new_world_path
        expect(response).to render_template('new')
      end
      it 'should check the redirect back to home page' do
        post '/worlds'
        expect(response).to redirect_to worlds_path
      end
      it 'should call the model method that performs world creation' do
        fake_params = { world_code: '11111', world_name: 'test', user_id: '0', is_public: true,
                        max_player: '5' }
        fake_results = World.new(fake_params)
        allow(World).to receive(:create).and_return(fake_results)
        post worlds_path, params: fake_params
        expect(assigns(:world)).to have_attributes(
          world_code: '11111',
          world_name: 'test',
          user_id: '0',
          is_public: true,
          max_player: '5'
        )
      end
    end
  end
  describe 'When a user is not logged in' do
    it 'should redirect to the login page' do
      get worlds_path
      expect(response).to redirect_to users_login_path
    end
  end
end
# rubocop:enable Metrics/BlockLength