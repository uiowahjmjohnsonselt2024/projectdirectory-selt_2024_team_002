# frozen_string_literal: true

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

    @user_world = UserWorld.find_by_ids(@cur_user[:id], @world[:id])
    puts("Enter quest log")
    puts(@user_world[:xp])

    #{respond_to do |format|
    #  format.js
    #end}
  end

  def cell_action
    @cur_user = User.find_user_by_session_token(cookies[:session])
    @world = World.find(params[:world_id])

    @user_world = UserWorld.find_by_ids(@cur_user[:id], @world[:id])
    puts("Enter action")
    puts(@user_world[:xp])

    #{respond_to do |format|
    #  format.js
    #end}
  end

  def cell_shop
    @cur_user = User.find_user_by_session_token(cookies[:session])
    @world = World.find(params[:world_id])

    @user_world = UserWorld.find_by_ids(@cur_user[:id], @world[:id])
    puts("Enter shop")
    puts(@user_world[:xp])

    #{respond_to do |format|
    #  format.js
    #end}
  end
end
