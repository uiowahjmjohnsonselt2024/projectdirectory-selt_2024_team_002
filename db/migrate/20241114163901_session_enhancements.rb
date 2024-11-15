# frozen_string_literal: true

# added partial index to the session token ONLY when the session token is not null
class SessionEnhancements < ActiveRecord::Migration
  def change
    add_index :users, :session_token, unique: true, where: 'session_token IS NOT NULL'
  end
end
