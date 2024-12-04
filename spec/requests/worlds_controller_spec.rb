# frozen_string_literal: true

require 'spec_helper'
require 'rails_helper'

describe WorldsController do
  let(:cur_user) { instance_double(User, id: 1) }
  let(:world) { instance_double(World, id: 1, current_players: 1, max_player: 2) }

  before do
    allow(User).to receive(:find_user_by_session_token).and_return(cur_user)
    allow(World).to receive(:find).and_return(world)
    allow(world).to receive(:update)
    allow(UserWorld).to receive_messages(find_or_create_by: instance_double(UserWorld),
                                         find_by: instance_double(UserWorld))
  end

  describe 'When a user is logged in' do
    before do
      allow(cur_user).to receive_messages(display_name: '', available_credits: 0, plus_user?: false)
      allow(Friendship).to receive_messages(friend_ids: [], requested_friend_ids: [])
    end

    describe 'leave world' do
      it 'leaves a world correctly' do
        allow(world).to receive(:current_players).and_return(10)
        expect(world).to receive(:update).with(current_players: 9)
        post worlds_leave_world_path, params: { id: 'world_1' }
      end

      it 'redirects correctly' do
        allow(world).to receive(:current_players).and_return(10)
        allow(world).to receive(:update).with(current_players: 9).and_return(true)
        post worlds_leave_world_path, params: { id: 'world_1' }
        expect(response).to redirect_to worlds_path
      end
    end

    describe 'join world' do
      it 'increases the current_players count by 1' do
        allow(world).to receive_messages(current_players: 1, max_player: 2)
        expect(world).to receive(:update).with(current_players: 2)
        post worlds_join_world_path, params: { id: 'world_1' }
      end

      it 'can\'t join a full world' do
        allow(world).to receive_messages(current_players: 2, max_player: 2)
        post worlds_join_world_path, params: { id: 'world_1' }
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
end
