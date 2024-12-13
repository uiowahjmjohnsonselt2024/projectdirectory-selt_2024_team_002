class BlackjackController < ApplicationController
    before_action :authenticate_user
    require 'json'

    
  def start_blackjack_game
    @cell = Gridsquare.find(params[:cell_id])
    @world = @cell.world
    @user = @cur_user

    if @user.available_credits >= @cell.buy_in_amount
      init_blackjack_game
      redirect_to action: :show_blackjack_game
    else
      redirect_to @world, alert: 'Insufficient credits to play'
    end
  end

  def hit_blackjack_game
    @game_state = session[:blackjack_game]

    # hit logic
  end

  def stand_blackjack_game
    @game_state = session[:blackjack_game]

    # stand logic
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