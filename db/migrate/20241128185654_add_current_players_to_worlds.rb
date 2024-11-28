class AddCurrentPlayersToWorlds < ActiveRecord::Migration[7.1]
  def change
    add_column :worlds, :current_players, :integer
  end
end
