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

    # {respond_to do |format|
    #  format.js
    # end}
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

  def cell_action
    @cur_user = User.find_user_by_session_token(cookies[:session])
    @world = World.find(params[:world_id])

    @user_world = UserWorld.find_by_ids(@cur_user.id, @world.id)
    Rails.logger.debug('Enter action')
    Rails.logger.debug(@user_world.xp)

    # {respond_to do |format|
    #  format.js
    # end}
  end

  def shop
    @cur_user = User.find_user_by_session_token(cookies[:session])
    @world = World.find(params[:world_id])
    @user_world = UserWorld.find_by_ids(@cur_user.id, @world.id)

    # @grid_shop = GridShop.find_or_create_by(grid: @gridsquare) do |grid_shop|
    #   # Create a new Shop and associate it with the GridShop
    #   @shop = Shop.create!(name: "Shop for Grid #{@gridsquare.id}")
    #   grid_shop.shop = @shop
    # end

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
      @cur_user.update(available_credits: @cur_user.available_credits - (list_of_items[item.item_name] * item.price))
    end

    redirect_to world_path(params[:world_id])
  end

  def inventory
    @cur_user = User.find_user_by_session_token(cookies[:session])
    @world = World.find(params[:world_id])
    @user_world = UserWorld.find_by_ids(@cur_user.id, @world.id)

    @inventory_items = InventoryItem.where(user_world_id: @user_world.id)

    respond_to do |format|
      format.js
    end
  end

  def use_item
    @cur_user = User.find_user_by_session_token(cookies[:session])
    @world = World.find(params[:world_id])
    @user_world = UserWorld.find_by_ids(@cur_user.id, @world.id)

    @item = Item.find(params[:item_id])
    @user_item = InventoryItem.find_by(user_world_id: @user_world.id, item_id: @item.id)

    case @user_item.name
    when 'XP Boost'
      @user_world.boost_xp
    when 'Speed Potion'
      @user_world.use_speed_potion
    when '4 Leaf Clover'
      # boost luck
      # add luck_boost column to user_world, default is false but using 4 Leaf Clover changes it to true
      # when user plays a mini game, they have improved odds of winning if luck_boost is true
      # lasts for the next 5 mini games they play
    else
      flash[:alert] = 'Item not found'
      redirect_to world_path
    end
    # @user_item.decrement(:quantity, 1)
    # @user_item.save
    redirect_to world_path
  end
  # rubocop:enable Metrics/MethodLength
end
