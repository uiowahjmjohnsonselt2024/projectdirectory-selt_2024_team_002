# frozen_string_literal: true

# This controller is responsible for handling all the actions related to the blackjack game.
class BlackjackController < ApplicationController
  before_action :authenticate_user
  require 'json'

  def authenticate_user
    @cur_user = User.find_user_by_session_token(cookies[:session])
    return if @cur_user

    flash[:alert] = 'Please login'
    redirect_to users_login_path
  end

  # rubocop:disable Metrics/MethodLength
  def update_user_credits
    @cur_user = User.find_user_by_session_token(cookies[:session])
    unless @cur_user
      redirect_to users_login_path, alert: 'Please login' and return
    end

    @world = World.find(params[:world_id])
    @user_world = UserWorld.find_by(user: @cur_user, world: @world)

    unless @user_world
      redirect_to world_path(@world), alert: 'User does not belong to this world' and return
    end

    @gridsquare = Gridsquare.find_by_row_col(@world.id, @user_world.user_row, @user_world.user_col)

    case params[:result]
    when 'win'
      @cur_user.charge_credits(-@gridsquare.buy_in_amount)
    when 'loss'
      @cur_user.charge_credits(@gridsquare.buy_in_amount)
    else
      redirect_to world_path(@world), alert: 'Invalid result' and return
    end

    render json: { shard_balance: @cur_user.available_credits }, status: :ok
  end
  # rubocop:enable Metrics/MethodLength
end