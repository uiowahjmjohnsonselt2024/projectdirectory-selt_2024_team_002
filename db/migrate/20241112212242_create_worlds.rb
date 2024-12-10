# frozen_string_literal: true

# Basic migration for creating the world table in the database.
class CreateWorlds < ActiveRecord::Migration[7.1]
  def change
    create_table :worlds do |t|
      t.string :world_code
      t.string :world_name
      t.references :user
      t.boolean :is_public
      t.string :max_player
      t.text :data
      t.timestamps null: false
    end
  end
end
