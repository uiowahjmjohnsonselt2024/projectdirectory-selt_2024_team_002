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
  end

  def new
    # default: render 'new' template
  end

  def create
    new_params = world_params
    new_params[:user_id_id] = @cur_user.id
    new_params[:current_players] = 0 # Ensure current_players is set to 0
  
    if new_params[:world_code].blank? || new_params[:world_name].blank? || new_params[:max_player].blank?
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
    @selected_world = World.find(params[:id].split('_')[1])

    if @selected_world.current_players >= @selected_world.max_player.to_i
      flash[:notice] = 'World is full. Please join another world.'
      redirect_to worlds_path
    else
      @selected_world.increment!(:current_players)
      redirect_to world_path(@selected_world)
    end
  end

  def add_world
    @world = World.create!(new_params)
    redirect_to new_world_path
  end

  def leave_world
    @selected_world = World.find(params[:id])
    if @selected_world.current_players > 0
      @selected_world.decrement!(:current_players)
    end
    redirect_to worlds_path
  end
end
