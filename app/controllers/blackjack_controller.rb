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

    flash[:alert] = 'Error updating credits' unless user.save
    redirect_to world_path(@world)
  end
  # rubocop:enable Metrics/MethodLength

  # rubocop:disable Metrics/MethodLength
  def start_blackjack_game
    @cur_user = User.find_user_by_session_token(cookies[:session])
    @world = World.find(params[:world_id])
    @user_world = UserWorld.find_by(user: @cur_user, world: @world)
    @gridsquare = Gridsquare.find_by_row_col(@world, @user_world.user_row, @user_world.user_col)

    if @user_world.user.available_credits >= @gridsquare.buy_in_amount
      @user_world.user.update(available_credits: @user_world.user.available_credits - @gridsquare.buy_in_amount)
      @game = BlackjackGame.create(user_world: @user_world)
      render partial: 'blackjack', locals: { game: @game }
    else
      render partial: 'blackjack/insufficient_credits'
    end
  end
  # rubocop:enable Metrics/MethodLength

  def show_blackjack_game
    @game = BlackjackGame.find(params[:id])
    render partial: 'blackjack/game', locals: { game: @game }
  end

  def hit_blackjack_game
    @game = BlackjackGame.find(params[:id])
    @game.hit
    render partial: 'blackjack/game', locals: { game: @game }
  end

  def stand_blackjack_game
    @game = BlackjackGame.find(params[:id])
    @game.stand
    render partial: 'blackjack/game', locals: { game: @game }
  end

  private

  def init_blackjack_game
    session[:blackjack_game] = {
      player_hand: [],
      dealer_hand: [],
      player_score: 0,
      dealer_score: 0,
      status: 'ongoing'
    }
  end
end

# find minimum bet amount from gridsquare
# check if user has enough credits
# check if luck_boost is active
