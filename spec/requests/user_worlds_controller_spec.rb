# frozen_string_literal: true

require 'rails_helper'
require 'spec_helper'

RSpec.describe UserWorld, type: :request do
  let(:cur_user) { double('usr') }
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
  end

  describe 'move user' do
    describe 'free move' do
      it 'should render ok json' do
        usrwrld = double('association')
        allow(usrwrld).to receive(:user_row).and_return(2)
        allow(usrwrld).to receive(:user_col).and_return(3)
        allow(usrwrld).to receive(:set_position).and_return(true)
        allow(UserWorld).to receive(:find_by_ids).and_return(usrwrld)
        post move_user_path, params: {world_id: 1, dest_row: 3, dest_col:3}
        expect(response).to have_http_status(:ok)
      end
    end

    describe 'paid move' do
      it 'should render 200 ok when sufficient credits' do
        usrwrld = double('association')
        allow(usrwrld).to receive(:user_row).and_return(2)
        allow(usrwrld).to receive(:user_col).and_return(3)
        allow(cur_user).to receive_messages(charge_credits: true)
        allow(usrwrld).to receive(:set_position).and_return(true)
        allow(UserWorld).to receive(:find_by_ids).and_return(usrwrld)
        post move_user_path, params: {world_id: 1, dest_row: 6, dest_col:6}
        expect(response).to have_http_status(:ok)
      end

      it 'should charge user 0.75 credits' do
        usrwrld = double('association')
        allow(usrwrld).to receive(:user_row).and_return(2)
        allow(usrwrld).to receive(:user_col).and_return(3)
        expect(cur_user).to receive(:charge_credits).with(0.75).and_return(true)
        allow(usrwrld).to receive(:set_position).and_return(true)
        allow(UserWorld).to receive(:find_by_ids).and_return(usrwrld)
        post move_user_path, params: {world_id: 1, dest_row: 6, dest_col:6}
      end

      it 'should render 400 bad_request when insufficient credits' do
        usrwrld = double('association')
        allow(usrwrld).to receive(:user_row).and_return(2)
        allow(usrwrld).to receive(:user_col).and_return(3)
        allow(cur_user).to receive_messages(charge_credits: false)
        allow(usrwrld).to receive(:set_position).and_return(true)
        allow(UserWorld).to receive(:find_by_ids).and_return(usrwrld)
        post move_user_path, params: {world_id: 1, dest_row: 6, dest_col:6}
        expect(response).to have_http_status(:bad_request)
      end
    end
  end

  describe 'items' do
    describe 'purchasing items' do
      it 'should purchase item with sufficient credits' do
        user_world_params = { id: 1, user_id: 1, world_id: 1, xp: 10 }
        item_params = { id: 1, item_name: "Test Item 1", price: 5.0 }
        inventory_params = { user_world_id: 1, item_id: 1, amount_available: 10 }
        user_world = instance_double(described_class, user_world_params)
        items = [instance_double('item', item_params), instance_double('item', id: 2, item_name: "Test Item 2", price: 1.0)]
        inventory = instance_double('InventoryItems', inventory_params)
        allow(cur_user).to receive(:available_credits).and_return(1000)
        allow(UserWorld).to receive(:find_by_ids).with(1, 1).and_return(user_world)
        allow(user_world).to receive(:id).and_return(1)
        allow(Item).to receive(:all).and_return(items)
        allow(Item).to receive(:where).and_return(items)
        allow(items[0]).to receive(:find_or_created_by).with(item_params).and_return(items[0])
        item = Item.where(id: 1)
        uw = UserWorld.find_by_ids(1, 1)
        allow(inventory).to receive(:find_or_create_by).with(user_world_id: uw.id, item_id: item[0].id).and_return(inventory)
        post purchase_item_path, params: {world_id: 1, items_id: '{"Test Item 1": 3, "Test Item 2": 4}'}


      end

      it 'should not purchase item with insufficient credits' do
        pending
      end
    end

    # describe 'using items' do
    #   it 'should increase my xp with xp booster' do
    #     pending
    #   end
    #
    #   it 'should allow me to move past adjacent cells with speed potion' do
    #     pending
    #   end
    #
    #   it 'should increase my mini game luck with 4 leaf clover' do
    #     pending
    #   end
    # end
  end
end
