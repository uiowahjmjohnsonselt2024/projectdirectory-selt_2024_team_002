class SessionEnhancements < ActiveRecord::Migration
  def change
    add_index :users, :session_token, unique: true, where: "session_token IS NOT NULL"
  end
end