# frozen_string_literal: true

require 'spec_helper'
require 'rails_helper'

# rubocop:disable Metrics/BlockLength
describe WorldsController do
  describe 'When a user is logged in' do
    before do
      usr = instance_double(User)
      allow(User).to receive(:find_user_by_session_token).and_return(usr)
      allow(usr).to receive_messages(display_name: '', available_credits: 0, plus_user?: false)
      allow(Friendship).to receive(:friend_ids).and_return([])
      allow(Friendship).to receive(:requested_friend_ids).and_return([])
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

      it 'checks the redirect back to new world page' do
        usr = instance_double(User)
        allow(User).to receive(:find_user_by_session_token).and_return(usr)
        allow(usr).to receive_messages(id: 1, plus_user?: false)
        post '/worlds'
        expect(response).to redirect_to new_world_path
      end

      # rubocop:disable RSpec/ExampleLength
      it 'calls the model method that performs world creation' do
        fake_params = { world_code: '11111', world_name: 'test', is_public: true, max_player: '5' }
        fake_results = World.new(fake_params)
        usr = instance_double(User)
        allow(World).to receive(:create).and_return(fake_results)
        allow(User).to receive(:find_user_by_session_token).and_return(usr)
        allow(usr).to receive_messages(id: 1, plus_user?: false)
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

    it 'renders the show template on show call' do
      world = double('world')
      collection = double('col')
      gridsquare = double('gs')
      image = double('image')
      allow(World).to receive(:dim).and_return(1)
      allow(World).to receive(:find).and_return(world)
      allow(world).to receive(:init_if_not_inited).and_return(world)
      allow(world).to receive(:gridsquares).and_return(collection)
      allow(world).to receive(:id).and_return(0)
      allow(world).to receive(:[]).and_return(0)
      allow(gridsquare).to receive(:row).and_return(1)
      allow(gridsquare).to receive(:col).and_return(1)
      allow(gridsquare).to receive(:image).and_return(image)
      allow(image).to receive(:attached?).and_return(false)
      allow(collection).to receive(:to_ary).and_return([gridsquare])
      get '/worlds/1'
      expect(response).to render_template('show')
    end

    describe 'leave world' do
      it 'leaves a world correctly' do
        world = double('world')
        allow(World).to receive(:find).and_return(world)
        allow(world).to receive(:current_players).and_return(10)
        expect(world).to receive(:update).with({ current_players: 9 }).and_return(10)

        post worlds_leave_world_path
      end

      it 'redirects correctly' do
        world = double('world')
        allow(World).to receive(:find).and_return(world)
        allow(world).to receive(:current_players).and_return(10)
        allow(world).to receive(:update).with({ current_players: 9 }).and_return(10)
        post worlds_leave_world_path
        expect(response).to redirect_to worlds_path
      end
    end

    describe 'join world' do
      it 'increases the current_players count by 1' do
        world = double('world')
        allow(World).to receive(:find).and_return(world)
        allow(world).to receive(:current_players).and_return(1)
        allow(world).to receive(:max_player).and_return(2)
        allow(world).to receive(:update).with({ current_players: 2 })
        post worlds_join_world_path, params: { id: '1' }
      end

      it 'can\'t join a full world' do
        world = double('world')
        allow(World).to receive(:find).and_return(world)
        allow(world).to receive(:current_players).and_return(2)
        allow(world).to receive(:max_player).and_return(2)
        post worlds_join_world_path, params: { id: '1' }
        expect(response).to redirect_to worlds_path
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
