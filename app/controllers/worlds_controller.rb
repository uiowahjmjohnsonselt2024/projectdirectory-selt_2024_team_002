# frozen_string_literal: true

# WorldController performs basic operations for world generation and state storage.
# rubocop:disable all
class WorldsController < ApplicationController
  before_action :authenticate_user
  before_action :index, only: [:index, :invite]

  def authenticate_user
    @cur_user = User.find_user_by_session_token(cookies[:session])
    return if @cur_user

    flash[:alert] = 'Please login'
    return redirect_to users_login_path
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
  end

  def index
    flash.discard
    @public_worlds = World.where(is_public: true)
    @private_worlds = World.joins(:user_worlds)
                           .where(is_public: false, user_worlds: { user: @cur_user, request: false })
    @shareable_worlds = World.joins(:user_worlds)
                           .where(is_public: false, user_id: @cur_user.id, user_worlds: { user: @cur_user, request: false })
    @friends = User.where(id: Friendship.friend_ids(@cur_user))
    @requested_friends = User.where(id: Friendship.requested_friend_ids(@cur_user))
    @world_invites = UserWorld.where( user: @cur_user, request: true )
  end

  def invite
    @friend = User.find_by_id(params[:friend_id])
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
      UserWorld.create(user: @cur_user, world: @world)
      flash[:notice] = 'World was successfully created.'
      redirect_to worlds_path
    end
  end

  def edit; end

  def update; end

  def destroy
    user_world = UserWorld.find_by(user_id: @cur_user.id, world_id: params[:id])
    world = World.find_by(id: params[:id])

    UserWorld.where(world_id: world.id).destroy_all
    Gridsquare.where(world_id: world.id).destroy_all
    Message.where(world_id: world.id).destroy_all
    OpenaiEvent.where(world_id: world.id).destroy_all

    if World.delete(world)
      @message = 'World deleted.'
    else
      @message = 'Error deleting world.'
    end
    redirect_to worlds_path
  end

  def join_world
    @selected_world = World.find(params[:id].split('_')[1])
    UserWorld.find_or_create_by(user: @cur_user, world: @selected_world)

    if @selected_world.current_players >= @selected_world.max_player.to_i
      flash[:notice] = 'World is full. Please join another world.'
      redirect_to worlds_path
    else
      get_url(@selected_world.id)
      unless params[:is_from_world]
        @selected_world.update(current_players: @selected_world.current_players + 1)
      end

      redirect_to world_path(@selected_world)
    end
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
    new_params[:user_id] = @cur_user.id
    new_params[:current_players] = 0 # Ensure current_players is set to 0
    new_params
  end

  def invalid_world_params?(params)
    max_players_limit = @cur_user.plus_user? ? 20 : 5
    params[:is_public] == '0' && params[:max_player].to_i > max_players_limit ||
      params[:world_code].blank? || params[:world_name].blank? || params[:max_player].blank?
  end
end
