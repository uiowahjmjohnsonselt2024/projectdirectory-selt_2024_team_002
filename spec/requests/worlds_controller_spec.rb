# frozen_string_literal: true

require 'spec_helper'
require 'rails_helper'

# rubocop:disable Metrics/BlockLength
describe WorldsController do
  describe 'When a user is logged in' do
    before do
      usr = instance_double(User)
      allow(User).to receive(:find_user_by_session_token).and_return(usr)
      allow(usr).to receive(:display_name).and_return('')
    end

    describe 'world page' do
      it 'renders the world page' do
        get worlds_path

        expect(response).to render_template('index')
      end
    end

    describe 'adding world' do
      it 'selects the Creating World template for rendering' do
        get new_world_path
        expect(response).to render_template('new')
      end

      it 'checks the redirect back to home page' do
        usr = instance_double(User)
        allow(User).to receive(:find_user_by_session_token).and_return(usr)
        allow(usr).to receive(:id).and_return(1)
        post '/worlds'
        expect(response).to redirect_to worlds_path
      end

      # rubocop:disable RSpec/ExampleLength
      it 'calls the model method that performs world creation' do
        fake_params = { world_code: '11111', world_name: 'test', is_public: true,
                        max_player: '5' }
        fake_results = World.new(fake_params)
        usr = instance_double(User)
        allow(World).to receive(:create).and_return(fake_results)
        allow(User).to receive(:find_user_by_session_token).and_return(usr)
        allow(usr).to receive(:id).and_return(1)
        post worlds_path, params: fake_params
        expect(assigns(:world)).to have_attributes(
          world_code: '11111',
          world_name: 'test',
          user_id_id: 1,
          is_public: true,
          max_player: '5'
        )
      end
    end
  end
  # rubocop:enable RSpec/ExampleLength

  describe 'When a user is not logged in' do
    it 'redirects to the login page' do
      get worlds_path
      expect(response).to redirect_to users_login_path
    end
  end
end
# rubocop:enable Metrics/BlockLength
