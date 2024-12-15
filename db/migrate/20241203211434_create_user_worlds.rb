# frozen_string_literal: true

# UserWorld class is a model class that represents the relationship between a user and a world.
class CreateUserWorlds < ActiveRecord::Migration[7.1]
  def change
    create_table :user_worlds do |t|
      t.references :user, null: false, foreign_key: true
      t.references :world, null: false, foreign_key: true
      t.integer :xp, default: 0, null: false
      t.integer :level, default: 1, null: false
      t.integer :world_max_xp, default: 100, null: false
      t.boolean :request, default: false

      t.timestamps
    end

    add_index :user_worlds, %i[user_id world_id], unique: true
  end
end
