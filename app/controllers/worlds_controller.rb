# frozen_string_literal: true

# WorldController performs basic operations for world generation and state storage.
class WorldsController < ApplicationController
  before_action :authenticate_user

  def authenticate_user
    @cur_user = User.find_user_by_session_token(cookies[:session])
    return if @cur_user

    flash[:alert] = 'Please login'
    redirect_to users_login_path
  end

  def world_params
    params.permit(:world_code, :world_name, :is_public, :max_player)
  end

  def show
    # TODO: if private world, check user access
    id = params[:id] # retrieve world ID from URI route
    @world = World.find(id)
    @world.init_if_not_inited
    @data = {}
    grid_arr = @world.gridsquares.to_ary
    grid_arr.each do |cell|
      @data[cell.row] ||= {}
      @data[cell.row][cell.col] = cell
    end
    # @world.enter_cell(0, 0)
  end

  def index
    flash.discard
    @public_worlds = World.where(is_public: true)
    @private_worlds = World.where(is_public: false)
    @user = User.find_user_by_session_token(cookies[:session])
    friend_ids = Friendship.where(friend_id: @user.id).pluck(:user_id).concat(Friendship.where(user_id: @user.id).pluck(:friend_id)).uniq
    @friends = User.where(id: friend_ids)
  end

  def new
    # default: render 'new' template
  end

  def create
    new_params = world_params
    new_params[:user_id_id] = @cur_user.id

    if new_params[:world_code] == '' || new_params[:world_name] == '' || new_params[:max_player] == ''
      flash[:notice] = 'Fields have not been fulfilled. Please check your inputs.'
      redirect_to new_world_path
    else
      @world = World.create!(new_params)
      flash[:notice] = 'World was successfully created.'
      redirect_to worlds_path
    end
  end

  def edit; end

  def update; end

  def destroy; end

  def join_world
    @selected_world = params[:id]
    redirect_to world_path(@selected_world.split('_')[1])
  end

  def add_world
    @world = World.create!(new_params)
    redirect_to new_world_path
  end
end
