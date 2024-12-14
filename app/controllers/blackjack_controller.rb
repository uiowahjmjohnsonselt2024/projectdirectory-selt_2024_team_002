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
    result = params[:result]
    @cur_user = User.find_user_by_session_token(cookies[:session])
    @world = World.find(params[:world_id])
    @user_world = UserWorld.find_by(user: @cur_user, world: @world)
    @gridsquare = Gridsquare.find_by_row_col(@world, @user_world.user_row, @user_world.user_col)

    case result
    when 'win'
      @cur_user.charge_credits(-@gridsquare.buy_in_amount) # negative value to add credits
    when 'loss'
      @cur_user.charge_credits(@gridsquare.buy_in_amount)
    else
      flash[:alert] = 'Invalid result'
      redirect_to world_path(@world)
    end

    flash[:alert] = 'Error updating credits' unless @cur_user.save
    @cur_user.available_credits
    render json: { shard_balance: @cur_user.available_credits }
  end
  # rubocop:enable Metrics/MethodLength
end

# find minimum bet amount from gridsquare
# check if user has enough credits
# check if luck_boost is active
