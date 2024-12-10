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
      # Charge failed, return 400 status
      charge_res = @cur_user.charge_credits(0.75)
      unless charge_res
        flash[:warning] = 'Insufficient credits!'
        return render json: { error: 'Insufficient credits!' }, status: :bad_request unless charge_res
      end

    end
    user_world.set_position(dest_row, dest_col)
    render json: { error: 'none' }, status: :ok
  end
  # rubocop:enable Metrics/MethodLength

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

  # rubocop:disable Metrics/MethodLength
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

  # rubocop:disable Metrics/MethodLength
  def purchase_item
    @cur_user = User.find_user_by_session_token(cookies[:session])
    @world = World.find(params[:world_id])
    @user_world = UserWorld.find_by_ids(@cur_user.id, @world.id)
    @items = Array.new
    list_of_items = JSON.parse(params[:items_id])

    list_of_items.each_key do |item|
      if list_of_items[item] != 0
        @items.push(Item.where(item_name: item).first)
      end
    end

    @items.each do |item|
      if @cur_user.available_credits < item.price
        @message = 'Insufficient shards!'
        puts("no money")
        respond_to do |format|
          format.js
        end
      end

      puts(item.item_name)

      @user_item = InventoryItem.find_or_create_by(user_world_id: @user_world.id, item_id: item.id)
      @user_item.increment(:amount_available, list_of_items[item.item_name])
      @cur_user.update(available_credits: @cur_user.available_credits - (list_of_items[item.item_name] * item.price))
    end

    redirect_to world_path(params[:world_id])
  end
  # rubocop:enable Metrics/MethodLength

  def use_item
    @cur_user = User.find_user_by_session_token(cookies[:session])
    @world = World.find(params[:world_id])
    @user_world = UserWorld.find_by_ids(@cur_user.id, @world.id)

    @item = Item.find(params[:item_id])
    @user_item = InventoryItem.find_by(user_world_id: @user_world.id, item_id: @item.id)
    # use the item
    case @item.name
    when 'XP Boost'
      # boost xp 
    when 'Speed Potion'
      # boost speed
    when '4 Leaf Clover'
      # boost luck
    else
      flash[:alert] = 'Item not found'
      redirect_to world_path
    end
    @user_item.decrement(:quantity, 1)
    @user_item.save
    redirect_to world_path
  end
end
