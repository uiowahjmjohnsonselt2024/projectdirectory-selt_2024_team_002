# frozen_string_literal: true

# Controller for handling user-world actions.
class UsersWorldsController < ApplicationController
  before_action :authenticate_user

  def authenticate_user
    @cur_user = User.find_user_by_session_token(cookies[:session])
    return if @cur_user

    flash[:alert] = 'Please login'
    redirect_to users_login_path
  end

  def cell_quest
    @cur_user = User.find_user_by_session_token(cookies[:session])
    @world = World.find(params[:world_id])

    @user_world = UserWorld.find_by_ids(@cur_user.id, @world.id)
    Rails.logger.debug('Enter quest log')
    Rails.logger.debug(@user_world.xp)

    # {respond_to do |format|
    #  format.js
    # end}
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
    Rails.logger.debug('Enter shop')
    Rails.logger.debug(@user_world.xp)
    @items = ["Item 1", "Item 2", "Item 3"]

    respond_to do |format|
      format.js
    end
  end
end
