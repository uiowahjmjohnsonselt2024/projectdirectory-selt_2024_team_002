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
        allow(usrwrld).to receive(:speed_boost?).and_return(true)
        allow(usrwrld).to receive(:update_speed_count)
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

      it 'should render 200 ok even when insufficient credits' do
        usrwrld = double('association')
        allow(usrwrld).to receive(:speed_boost?).and_return(true)
        allow(usrwrld).to receive(:update_speed_count)
        allow(usrwrld).to receive(:user_row).and_return(2)
        allow(usrwrld).to receive(:user_col).and_return(3)
        allow(cur_user).to receive_messages(charge_credits: false)
        allow(usrwrld).to receive(:quests).and_return(quests)
        allow(quests).to receive(:find_by).and_return(nil)
        allow(usrwrld).to receive(:set_position).with("6", "6").and_return(true)
        allow(UserWorld).to receive(:find_by_ids).and_return(usrwrld)
        post move_user_path, params: {world_id: 1, dest_row: 6, dest_col: 6}
        expect(response).to have_http_status(:ok)
      end

      it 'should render 304 bad request when insufficient credits and no speed boost yet' do
        usrwrld = double('association')
        allow(usrwrld).to receive(:speed_boost?).and_return(false)
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

  describe 'items' do
    describe 'purchasing items' do
      it 'should open the shop and has items display' do
        user_world_params = { id: 1, user_id: 1, world_id: 1, xp: 10 }
        item_params = { id: 1, item_name: "Test Item 1", price: 5.0 }
        item_params_2 = { id: 2, item_name: "Test Item 2", price: 1.0 }
        user_world = instance_double(described_class, user_world_params)
        items = [instance_double('item', item_params), instance_double('item', item_params_2)]
        allow(cur_user).to receive(:available_credits).and_return(1000)
        allow(UserWorld).to receive(:find_by_ids).with(1, 1).and_return(user_world)
        allow(user_world).to receive(:id).and_return(1)
        allow(Item).to receive(:all).and_return(items)
        post shop_path, params: {world_id: 1}

        expect(response).to have_http_status(:ok)
      end

      it 'should purchase item with sufficient credits' do
        user_world_params = { id: 1, user_id: 1, world_id: 1, xp: 10 }
        item_params = { id: 1, item_name: "Test Item 1", price: 5.0 }
        item_params_2 = { id: 2, item_name: "Test Item 2", price: 1.0 }
        inventory_params = { user_world_id: 1, item_id: 1, amount_available: 10 }
        user_world = instance_double(described_class, user_world_params)
        items = [instance_double('item', item_params), instance_double('item', item_params_2)]
        inventory = instance_double('InventoryItems', inventory_params)
        allow(cur_user).to receive(:available_credits).and_return(1000)
        allow(UserWorld).to receive(:find_by_ids).with(1, 1).and_return(user_world)
        allow(user_world).to receive(:id).and_return(1)
        allow(Item).to receive(:all).and_return(items)
        allow(Item).to receive(:where).and_return(items)
        allow(items[0]).to receive(:find_or_created_by).with(item_params).and_return(items[0])
        allow(items[1]).to receive(:find_or_created_by).with(item_params_2).and_return(items[1])
        item = Item.where(id: 1)
        uw = UserWorld.find_by_ids(1, 1)
        allow(inventory).to receive(:find_or_create_by).with(user_world_id: uw.id, item_id: item[0].id).and_return(inventory)
        allow(cur_user).to receive(:update).with(available_credits: 985).and_return(cur_user)
        post purchase_item_path, params: {world_id: 1, items_id: '{"Test Item 1": 3, "Test Item 2": 4}'}

        expect(response).to redirect_to(world_path(user_world.world_id))
      end

      it 'should not purchase item with insufficient credits' do
        user_world_params = { id: 1, user_id: 1, world_id: 1, xp: 10 }
        item_params = { id: 1, item_name: "Test Item 1", price: 5.0 }
        item_params_2 = { id: 2, item_name: "Test Item 2", price: 1.0 }
        user_world = instance_double(described_class, user_world_params)
        items = [instance_double('item', item_params), instance_double('item', item_params_2)]
        allow(cur_user).to receive(:available_credits).and_return(0)
        allow(UserWorld).to receive(:find_by_ids).with(1, 1).and_return(user_world)
        allow(user_world).to receive(:id).and_return(1)
        allow(Item).to receive(:all).and_return(items)
        allow(Item).to receive(:where).and_return(items)
        allow(items[0]).to receive(:find_or_created_by).with(item_params).and_return(items[0])
        allow(items[1]).to receive(:find_or_created_by).with(item_params_2).and_return(items[1])
        post purchase_item_path, params: {world_id: 1, items_id: '{"Test Item 1": 3, "Test Item 2": 4}'}

        expect(response).to redirect_to(world_path(user_world.world_id))
      end

      describe 'inventory' do
        it 'should store user items' do
          user_world_params = { id: 1, user_id: 1, world_id: 1, xp: 10 }
          item_params = { id: 1, item_name: "Test Item 1", price: 5.0 }
          item_params_2 = { id: 2, item_name: "Test Item 2", price: 1.0 }
          user_world = instance_double(described_class, user_world_params)
          items = [instance_double('item', item_params), instance_double('item', item_params_2)]
          allow(cur_user).to receive(:available_credits).and_return(0)
          allow(UserWorld).to receive(:find_by_ids).with(1, 1).and_return(user_world)
          allow(user_world).to receive(:id).and_return(1)
          allow(Item).to receive(:all).and_return(items)
          allow(Item).to receive(:where).and_return(items)
          allow(items[0]).to receive(:find_or_created_by).with(item_params).and_return(items[0])
          allow(items[1]).to receive(:find_or_created_by).with(item_params_2).and_return(items[1])
          post purchase_item_path, params: {world_id: 1, items_id: '{"Test Item 1": 3, "Test Item 2": 4}'}

          res = [instance_double('InventoryItem', { user_world_id: 1, item_id: 1, amount_available: 1 })]
          allow(InventoryItem).to receive(:find_by).with(user_world_id: user_world.id).and_return(res)

          post inventory_path, params: {world_id: 1}
          expect(response).to have_http_status(:ok)
        end

        it 'should display with no items' do
          user_world_params = { id: 1, user_id: 1, world_id: 1, xp: 10 }
          user_world = instance_double(described_class, user_world_params)
          allow(cur_user).to receive(:available_credits).and_return(0)
          allow(UserWorld).to receive(:find_by_ids).with(1, 1).and_return(user_world)
          allow(user_world).to receive(:id).and_return(1)

          post inventory_path, params: {world_id: 1}
          expect(response).to have_http_status(:ok)
        end

        it 'should use the items' do
          user_world_params = { id: 1, user_id: 1, world_id: 1, xp: 10 }
          user_item_params = { id: 1, user_world_id: 1, item_name: "XP Boost", amount_available: 5 }
          user_world = instance_double(described_class, user_world_params)
          user_item = instance_double(InventoryItem, user_item_params)
          allow(cur_user).to receive(:available_credits).and_return(0)
          allow(UserWorld).to receive(:find_by_ids).with(1, 1).and_return(user_world)
          allow(user_world).to receive(:id).and_return(1)
          allow(InventoryItem).to receive(:find_by).with(id: "1").and_return(user_item)
          allow(user_item).to receive(:id).and_return(user_item)
          allow(user_item).to receive(:consume_item).and_return(user_world)
          post use_item_path, params: {world_id: 1, inventory_item_id: 1}

          expect(response).to redirect_to(world_path(user_world.world_id))
        end
      end
    end
  end
end
