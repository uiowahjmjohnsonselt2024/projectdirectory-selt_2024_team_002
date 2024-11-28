# frozen_string_literal: true

# This migration adds a boolean column to the users table to indicate if a user is a plus user.
class AddPlusUserToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :plus_user, :boolean
  end
end
