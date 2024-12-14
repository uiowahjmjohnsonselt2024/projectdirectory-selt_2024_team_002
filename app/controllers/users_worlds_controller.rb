# frozen_string_literal: true

# Controller for handling user-world actions.
class UsersWorldsController < ApplicationController
  before_action :authenticate_user
  require 'json'

  def authenticate_user
    @cur_user = User.find_user_by_session_token(cookies[:session])
    return if @cur_user

    flash[:alert] = 'Please login'
    redirect_to users_login_path
  end

  def cell_quest
    world = params[:world_id]
    @user_world = UserWorld.find_by_ids(@cur_user.id, world)
  end

  # rubocop:disable Metrics/MethodLength
  def move_user
    world = params[:world_id]
    user_world = UserWorld.find_by_ids(@cur_user.id, world)
    row = user_world.user_row
    col = user_world.user_col
    dest_row = params[:dest_row]
    dest_col = params[:dest_col]

    isfree = UserWorld.free_move?(row, col, dest_row, dest_col)

    unless isfree
      if user_world.speed_boost?
        user_world.update_speed_count
      else
        charge_res = @cur_user.charge_credits(0.75)
        unless charge_res
          flash[:alert] = 'Insufficient credits!'
          return render json: { error: 'Insufficient credits!' }, status: :bad_request
        end
      end
    end

    user_world.set_position(dest_row, dest_col)
    Quest.check_and_complete_movement_quest(user_world, dest_row, dest_col)
    render json: { error: 'none' }, status: :ok
  end

  def shop
    @cur_user = User.find_user_by_session_token(cookies[:session])
    @world = World.find(params[:world_id])
    @user_world = UserWorld.find_by_ids(@cur_user.id, @world.id)

    @items = Item.all

    respond_to do |format|
      format.js
    end
  end

  def purchase_item
    @cur_user = User.find_user_by_session_token(cookies[:session])
    @world = World.find(params[:world_id])
    @user_world = UserWorld.find_by_ids(@cur_user.id, @world.id)
    @items = []
    list_of_items = JSON.parse(params[:items_id])

    list_of_items.each_key do |item|
      @items.push(Item.where(item_name: item).first) if list_of_items[item] != 0
    end

    @items.each do |item|
      if @cur_user.available_credits < (list_of_items[item.item_name] * item.price)
        flash[:alert] = 'No sufficient shard to purchase'
        break
      end

      @user_item = InventoryItem.find_or_create_by(user_world_id: @user_world.id, item_id: item.id)
      @user_item.increment(:amount_available, list_of_items[item.item_name])
      @user_item.update(item_name: item.item_name)
      @user_item.save
      @cur_user.update(available_credits: @cur_user.available_credits - (list_of_items[item.item_name] * item.price))

      flash[:alert] = if @items.length == 1
                        "Bought #{@items[0].item_name} item."
                      else
                        "Bought #{@items[0].item_name} item and more."
                      end
    end

    redirect_to world_path(params[:world_id])
  end

  def inventory
    @cur_user = User.find_user_by_session_token(cookies[:session])
    @world = World.find(params[:world_id])
    @user_world = UserWorld.find_by_ids(@cur_user.id, @world.id)

    @inventory_items = InventoryItem.where(user_world_id: @user_world&.id).order(item_name: :asc)

    respond_to do |format|
      format.js
    end
  end

  def use_item
    @cur_user = User.find_user_by_session_token(cookies[:session])
    @world = World.find(params[:world_id])
    @user_world = UserWorld.find_by_ids(@cur_user.id, @world.id)

    @user_item = InventoryItem.find_by(id: params[:inventory_item_id])

    item_name = @user_item.consume_item

    flash[:alert] = "#{item_name} was used!"
    redirect_to world_path(params[:world_id])
  end
  # rubocop:enable Metrics/MethodLength
end
