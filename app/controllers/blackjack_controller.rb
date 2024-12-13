class BlackjackController < ApplicationController
    before_action :authenticate_user
    require 'json'

    
    def start_blackjack_game
        @cell = Gridsquare.find(params[:cell_id])
        @world = @cell.world
        @user_world = UserWorld.find_by(user: current_user, world: @world)

        if @user_world.user.available_credits >= @cell.buy_in_amount
            @user_world.user.update(available_credits: @user_world.user.available_credits - @cell.buy_in_amount)
            @game = BlackjackGame.create(user_world: @user_world)
            render partial: 'blackjack/game', locals: { game: @game }
        else
            render partial: 'blackjack/insufficient_credits'
        end
    end

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