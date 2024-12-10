# frozen_string_literal: true

class AddMessage < ActiveRecord::Migration[7.0]
  def change
    create_table :messages do |t|
      t.references :world, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.text :message, null: false
      t.timestamps
    end

    # add_index :messages, :world_id
    # add_index :messages, :user_id
    # add_index :messages, :created_at
  end
end
