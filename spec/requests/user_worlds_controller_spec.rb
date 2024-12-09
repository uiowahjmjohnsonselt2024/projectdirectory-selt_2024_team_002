# frozen_string_literal: true

require 'rails_helper'
require 'spec_helper'

RSpec.describe UserWorld, type: :request do
  let(:cur_user) { instance_double(User, id: 1) }
  let(:world) { instance_double(World, id: 1, current_players: 1, max_player: 2) }
  let(:user_world) { instance_double(described_class, xp: 1) }

  before do
    allow(User).to receive(:find_user_by_session_token).and_return(cur_user)
    allow(World).to receive(:find).and_return(world)
    allow(described_class).to receive(:find_by_ids).and_return(user_world)
    allow(cur_user).to receive_messages(id: 1)
    allow(world).to receive_messages(id: 1)
    allow(user_world).to receive_messages(xp: 1, world_id: 1, user_id: 1)
  end

  describe 'user_world' do
    it 'finds xp from associated user' do
      user_world = described_class.find_by_ids(1, 1)
      expect(user_world.xp).to eq 1
    end
  end

  describe 'user_world actions' do
    it 'accesses quests' do
      allow(UserWorld).to receive(:find_by_ids)
      post cell_quest_path(world.id), params: {world_id: 1}
      expect(response).to have_http_status(:no_content)
    end

    it 'accesses actions' do
      post cell_action_path(world.id)
      expect(response).to have_http_status(:no_content)
    end

    it 'accesses shops' do
      post cell_shop_path(world.id)
      expect(response).to have_http_status(:no_content)
    end
  end
end
