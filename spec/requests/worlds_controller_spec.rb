# frozen_string_literal: true

require 'spec_helper'
require 'rails_helper'

# rubocop:disable Metrics/BlockLength
describe WorldsController do
  let(:cur_user) { instance_double(User, id: 1) }
  let(:world) { instance_double(World, id: 1, current_players: 1, max_player: 2) }

  before do
    allow(User).to receive(:find_user_by_session_token).and_return(cur_user)
    allow(World).to receive(:find).and_return(world)
    allow(world).to receive(:update)
    allow(UserWorld).to receive(:find_or_create_by).and_return(instance_double(UserWorld))
    allow(UserWorld).to receive(:find_by).and_return(instance_double(UserWorld))
  end

  describe 'When a user is logged in' do
    before do
      allow(cur_user).to receive(:display_name).and_return('')
      allow(cur_user).to receive(:available_credits).and_return(0)
      allow(cur_user).to receive(:plus_user?).and_return(false)
      allow(Friendship).to receive(:friend_ids).and_return([])
      allow(Friendship).to receive(:requested_friend_ids).and_return([])
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
        allow(world).to receive(:current_players).and_return(1)
        allow(world).to receive(:max_player).and_return(2)
        expect(world).to receive(:update).with(current_players: 2)
        post worlds_join_world_path, params: { id: 'world_1' }
      end

      it 'can\'t join a full world' do
        allow(world).to receive(:current_players).and_return(2)
        allow(world).to receive(:max_player).and_return(2)
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