class SessionEnhancements < ActiveRecord::Migration
  class AddSessionTtlToUsers < ActiveRecord::Migration[6.0]
    def change
      add_index :users, :session_token, unique: true, where: "session_token IS NOT NULL"
    end
  end
end
