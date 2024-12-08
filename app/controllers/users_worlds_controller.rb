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
    @world = World.find(params[:world_id])

    @user_world = UserWorld.find_by_ids(@cur_user.id, @world.id)
    Rails.logger.debug('Enter quest log')
    Rails.logger.debug(@user_world.xp)

    # {respond_to do |format|
    #  format.js
    # end}
  end

  def move_user
    @world = World.find(params[:world_id])
    user_world = UserWorld.find_by_ids(@cur_user.id, @world.id)
    row = user_world.user_row
    col = user_world.user_col
    dest_row = params[:dest_row]
    dest_col = params[:dest_col]
    isfree = UserWorld.free_move?(row, col, dest_row, dest_col)

    unless isfree
      # Charge failed, return 400 status
      charge_res = @cur_user.charge_credits(0.75)
      Rails.logger.info(charge_res)
      return render json: { error: 'Insufficient credits!' }, status: :bad_request unless charge_res

      Rails.logger.info('here')
    end
    user_world.set_position(dest_row, dest_col)
    render text: 'ok', status: :ok
  end

  def cell_action
    @world = World.find(params[:world_id])

    @user_world = UserWorld.find_by_ids(@cur_user.id, @world.id)
    Rails.logger.debug('Enter action')
    Rails.logger.debug(@user_world.xp)

    # {respond_to do |format|
    #  format.js
    # end}
  end

  def cell_shop
    @world = World.find(params[:world_id])

    @user_world = UserWorld.find_by_ids(@cur_user.id, @world.id)
    Rails.logger.debug('Enter shop')
    Rails.logger.debug(@user_world.xp)

    # {respond_to do |format|
    #  format.js
    # end}
  end
end
