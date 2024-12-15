# frozen_string_literal: true

require 'spec_helper'
require 'rails_helper'

# rubocop:disable Metrics/BlockLength
describe WorldsController do
  let(:cur_user) { instance_double(User, id: 1) }
  let(:world) { instance_double(World, id: 1, current_players: 1, max_player: 2) }
  let(:quests) { double('quests') }
  let(:incomplete_quests) { double('incomplete_quest', completed: false) }
  let(:gridsquare) { double('gridsquare') }

  before do
    allow(User).to receive(:find_user_by_session_token).and_return(cur_user)
    allow(World).to receive(:find).and_return(world)
    allow(world).to receive(:update)
    allow(UserWorld).to receive_messages(find_or_create_by: instance_double(UserWorld),
                                         find_by: instance_double(UserWorld)
                                         )
    allow(quests).to receive(:where).with(completed: false).and_return(incomplete_quests)
    allow(incomplete_quests).to receive(:first).and_return(nil)
    allow(world).to receive(:gridsquares).and_return([gridsquare])
  end

  describe 'When a user is logged in' do
    before do
      usr = instance_double(User)
      allow(User).to receive(:find_user_by_session_token).and_return(usr)
      allow(usr).to receive_messages(display_name: '', available_credits: 0, plus_user?: false)
      allow(Friendship).to receive_messages(
        friend_ids: [],
        requested_friend_ids: []
      )
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

    # rubocop:disable RSpec/VerifiedDoubles
    it 'renders the show template' do
      collection = double('collection')
      image = double('image')
      allow(World).to receive(:dim).and_return(1)
      user_world = instance_double(UserWorld, user_row: 1, user_col: 1, quests: quests,)
      allow(user_world).to receive("[]")
      allow(world).to receive_messages(
                        init_if_not_inited: world,
                        gridsquares: [gridsquare],
                        id: 0,
                        "[]": 0,
                        generate_quest_for: nil
                      )
      allow(collection).to receive(:to_ary).and_return([gridsquare])
      any = double('any')
      allow(any).to receive(:any?).and_return false
      allow(quests).to receive(:reject).and_return(any)
      allow(gridsquare).to receive_messages(
                             row: 1,
                             col: 1,
                             image: image
                           )
      allow(image).to receive(:attached?).and_return(false)
      allow(collection).to receive(:to_ary).and_return([gridsquare])
      allow(User).to receive(:find_user_by_session_token).and_return(cur_user)
      allow(World).to receive(:find).and_return(world)
      allow(UserWorld).to receive(:find_by_ids).and_return(user_world)
      allow(UserWorld).to receive(:find_known_squares).and_return([[1, 1]])
      allow(cur_user).to receive_messages(id: 1, available_credits: 10)
      allow(user_world).to receive(:level).and_return(1)
      get '/worlds/1'
      expect(response).to render_template('show')
    end

    describe 'leave world' do
      it 'leaves a world correctly' do
        world = double('world')
        allow(World).to receive(:find).and_return(world)
        allow(world).to receive(:current_players).and_return(10)
        expect(world).to receive(:update).with({ current_players: 9 })
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
        allow(world).to receive_messages(
          current_players: 1,
          max_player: 2
        )
        expect(world).to receive(:update).with({ current_players: 2 })
        expect(world).to receive(:id).and_return(1)
        post worlds_join_world_path, params: { id: '1' }
      end

      it 'can\'t join a full world' do
        world = double('world')
        allow(World).to receive(:find).and_return(world)
        allow(world).to receive_messages(
          current_players: 2,
          max_player: 2
        )
        post worlds_join_world_path, params: { id: '1' }
        expect(response).to redirect_to worlds_path
      end

      it 'has an xp column set to 0 initially' do
        user_world = instance_double(UserWorld, xp: 0)
        allow(UserWorld).to receive(:find_or_create_by).and_return(user_world)
        post worlds_join_world_path, params: { id: 'world_1' }
        expect(user_world.xp).to eq(0)
      end
    end
  end

  # rubocop:enable RSpec/ExampleLength
  # rubocop:enable RSpec/VerifiedDoubles

  describe 'When a user is not logged in' do
    before do
      allow(User).to receive(:find_user_by_session_token).and_return(nil)
    end

    it 'redirects to the login page' do
      get worlds_path
      expect(response).to redirect_to users_login_path
    end
  end
end
# rubocop:enable Metrics/BlockLength
