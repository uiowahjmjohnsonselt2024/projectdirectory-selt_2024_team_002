# frozen_string_literal: true

# Adds a column to the worlds table to store the number of current players in the world.
class AddCurrentPlayersToWorlds < ActiveRecord::Migration[7.1]
  def change
    add_column :worlds, :current_players, :integer
  end
end
