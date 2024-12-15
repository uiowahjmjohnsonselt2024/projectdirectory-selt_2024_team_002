class AddStateToBlackjackGames < ActiveRecord::Migration[7.1]
  def change
    add_column :blackjack_games, :state, :text
  end
end
