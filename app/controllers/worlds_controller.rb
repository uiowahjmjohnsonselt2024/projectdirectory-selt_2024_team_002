# frozen_string_literal: true

# WorldController performs basic operations for world generation and state storage.
# rubocop:disable all
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

  def get_url(world_id)
    cookies[:previous_url] = request.path
    cookies[:world_id] = world_id
  end

  def show
    # TODO: if private world, check user access
    id = params[:id] # retrieve world ID from URI route
    @world = World.find(id)
    @world.init_if_not_inited
    @data = {}
    @user_world = UserWorld.find_by_ids(@cur_user.id, @world.id)
    @pos_row = @user_world.user_row
    @pos_col = @user_world.user_col
    grid_arr = @world.gridsquares.to_a
    allowed = UserWorld.find_known_squares(@cur_user.id, @world.id)
    grid_arr.each do |cell|
      @data[cell.row] ||= {}
      
      @data[cell.row][cell.col] = allowed.include?([cell.row.to_s, cell.col.to_s]) ? cell : :none
    end

    set_quest
  end

  def index
    flash.discard
    @public_worlds = World.where(is_public: true)
    @private_worlds = World.where(is_public: false)
    @friends = User.where(id: Friendship.friend_ids(@cur_user))
    @requested_friends = User.where(id: Friendship.requested_friend_ids(@cur_user))
  end

  def set_quest
    @quests = @user_world.quests
    @quest = @quests.where(completed: false).first
  
    if @quest
      gridsquare = @world.gridsquares.find_by(row: @quest.cell_row, col: @quest.cell_col)
      if gridsquare
        cell_desc = gridsquare.description
        @random_quest_message ||= Quest.random_quest_message(cell_desc)
      else
        @random_quest_message ||= "No description available for the quest location"
      end
    else
      @random_quest_message ||= "No active quests"
    end
  end

  def new
    @cur_user = User.find_user_by_session_token(cookies[:session])
    # default: render 'new' template
  end

  def create
    new_params = build_world_params

    if invalid_world_params?(new_params)
      flash[:notice] =
        'You have exceeded the worlds player limit. If you would like to upgrade from 5 to 20 purchase plus user.'
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
    UserWorld.find_or_create_by(user: @cur_user, world: @selected_world)

    if @selected_world.current_players >= @selected_world.max_player.to_i
      flash[:notice] = 'World is full. Please join another world.'
      redirect_to worlds_path
    else
      get_url(@selected_world.id)
      @selected_world.update(current_players: @selected_world.current_players + 1)
      redirect_to world_path(@selected_world)
    end
  end

  def add_world
    @world = World.create!(new_params)
    redirect_to new_world_path
  end

  def leave_world
    cookies.delete(:previous_url)
    cookies.delete(:world_id)
    @selected_world = World.find(params[:id])
    UserWorld.find_by(user: @cur_user, world: @selected_world)

    if @selected_world.current_players.positive?
      @selected_world.update(current_players: @selected_world.current_players - 1)
    end

    redirect_to worlds_path
  end

  private

  def build_world_params
    new_params = world_params
    new_params[:user_id_id] = @cur_user.id
    new_params[:current_players] = 0 # Ensure current_players is set to 0
    new_params
  end

  def invalid_world_params?(params)
    max_players_limit = @cur_user.plus_user? ? 20 : 5
    params[:is_public] == '0' && params[:max_player].to_i > max_players_limit ||
      params[:world_code].blank? || params[:world_name].blank? || params[:max_player].blank?
  end
end
