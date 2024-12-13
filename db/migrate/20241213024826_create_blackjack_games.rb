class CreateBlackjackGames < ActiveRecord::Migration[7.1]
  def change
    create_table :blackjack_games do |t|
      t.references :user_world, foreign_key: true
      t.integer :hand_value, default: 0

      t.timestamps
    end
  end
end
