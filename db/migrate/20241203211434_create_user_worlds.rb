# frozen_string_literal: true

# UserWorld class is a model class that represents the relationship between a user and a world.
class CreateUserWorlds < ActiveRecord::Migration[7.1]
  def change
    create_table :user_worlds do |t|
      t.references :user, null: false, foreign_key: true
      t.references :world, null: false, foreign_key: true
      t.integer :xp, default: 0, null: false
      t.boolean :request, null: false
      t.timestamps
    end

    add_index :user_worlds, %i[user_id world_id], unique: true
  end
end
