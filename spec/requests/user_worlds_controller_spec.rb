# frozen_string_literal: true

require 'rails_helper'
require 'spec_helper'

RSpec.describe UserWorld, type: :request do
  let(:cur_user) { double('usr') }
  let(:world) { instance_double(World, id: 1, current_players: 1, max_player: 2) }
  let(:user_world) { instance_double(described_class, xp: 1) }
  let(:quests) { double('quests') }

  before do
    allow(User).to receive(:find_user_by_session_token).and_return(cur_user)
    allow(World).to receive(:find).and_return(world)
    allow(described_class).to receive(:find_by_ids).and_return(user_world)
    allow(cur_user).to receive_messages(id: 1)
    allow(world).to receive_messages(id: 1)
    allow(user_world).to receive_messages(xp: 1, world_id: 1, user_id: 1)
    allow(user_world).to receive(:quests).and_return(quests)
    allow(quests).to receive(:find_by).and_return(nil)
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

  describe 'move user' do
    describe 'free move' do
      it 'should render ok json' do
        usrwrld = double('association')
        allow(usrwrld).to receive(:user_row).and_return(2)
        allow(usrwrld).to receive(:user_col).and_return(3)
        allow(usrwrld).to receive(:quests).and_return(quests)
        allow(quests).to receive(:find_by).and_return(nil)
        allow(usrwrld).to receive(:set_position).with("3", "3").and_return(true)
        allow(UserWorld).to receive(:find_by_ids).and_return(usrwrld)
        post move_user_path, params: {world_id: 1, dest_row: 3, dest_col: 3}
        expect(response).to have_http_status(:ok)
      end
    end

    describe 'paid move' do
      it 'should render 200 ok when sufficient credits' do
        usrwrld = double('association')
        allow(usrwrld).to receive(:user_row).and_return(2)
        allow(usrwrld).to receive(:user_col).and_return(3)
        allow(cur_user).to receive_messages(charge_credits: true)
        allow(usrwrld).to receive(:quests).and_return(quests)
        allow(quests).to receive(:find_by).and_return(nil)
        allow(usrwrld).to receive(:set_position).with("6", "6").and_return(true)
        allow(UserWorld).to receive(:find_by_ids).and_return(usrwrld)
        post move_user_path, params: {world_id: 1, dest_row: 6, dest_col: 6}
        expect(response).to have_http_status(:ok)
      end

      it 'should render 400 bad_request when insufficient credits' do
        usrwrld = double('association')
        allow(usrwrld).to receive(:user_row).and_return(2)
        allow(usrwrld).to receive(:user_col).and_return(3)
        allow(cur_user).to receive_messages(charge_credits: false)
        allow(usrwrld).to receive(:quests).and_return(quests)
        allow(quests).to receive(:find_by).and_return(nil)
        allow(usrwrld).to receive(:set_position).with("6", "6").and_return(true)
        allow(UserWorld).to receive(:find_by_ids).and_return(usrwrld)
        post move_user_path, params: {world_id: 1, dest_row: 6, dest_col: 6}
        expect(response).to have_http_status(:bad_request)
      end
    end
  end
end