# frozen_string_literal: true

# migration to create the users table
class CreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :users do |t|
      t.string :email
      t.text :password_digest
      t.text :session_token
      t.integer :available_credits
      t.string :display_name

      t.timestamps null: false
    end
    add_index :users, :display_name, unique: true
  end
end
