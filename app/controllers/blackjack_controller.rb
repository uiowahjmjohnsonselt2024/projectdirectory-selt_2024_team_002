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
  def buy_in
    @cur_user = User.find_user_by_session_token(cookies[:session])
    redirect_to users_login_path, alert: 'Please login' and return unless @cur_user

    @world = World.find(params[:world_id])
    @user_world = UserWorld.find_by(user: @cur_user, world: @world)
    redirect_to world_path(@world), alert: 'User does not belong to this world' and return unless @user_world

    @gridsquare = Gridsquare.find_by_row_col(@world.id, @user_world.user_row, @user_world.user_col)
    has_enough_credits = @cur_user.available_credits >= @gridsquare.buy_in_amount
    unless has_enough_credits
      params = { has_enough_credits: has_enough_credits, shard_balance: @cur_user.available_credits }
      return render json: params, status: :ok
    end

    @cur_user.charge_credits(@gridsquare.buy_in_amount)
    params = {
      has_enough_credits: has_enough_credits,
      luck_boost: @user_world.luck_boost,
      shard_balance: @cur_user.available_credits
    }
    render json: params, status: :ok
  end
  # rubocop:enable Metrics/MethodLength

  def update_user_credits
    @cur_user = User.find_user_by_session_token(cookies[:session])
    redirect_to users_login_path, alert: 'Please login' and return unless @cur_user

    @world = World.find(params[:world_id])
    @user_world = UserWorld.find_by(user: @cur_user, world: @world)

    redirect_to world_path(@world), alert: 'User does not belong to this world' and return unless @user_world

    @gridsquare = Gridsquare.find_by_row_col(@world.id, @user_world.user_row, @user_world.user_col)

    return unless process_result(params[:result])

    render json: { shard_balance: @cur_user.available_credits }, status: :ok
  end

  # rubocop:disable Metrics/MethodLength
  def process_result(result)
    @user_world.update_luck_count if @user_world.luck_boost

    case result
    when 'win'
      @cur_user.charge_credits(-2 * @gridsquare.buy_in_amount)
    when 'buy_in'
      @cur_user.charge_credits(@gridsquare.buy_in_amount)
    when 'push'
      @cur_user.charge_credits(-@gridsquare.buy_in_amount)
    else
      redirect_to world_path(@world), alert: 'Invalid result'
      return false
    end
    true
  end
  # rubocop:enable Metrics/MethodLength
end
