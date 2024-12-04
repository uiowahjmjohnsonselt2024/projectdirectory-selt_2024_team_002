# frozen_string_literal: true

# adds reset password token and timestamp to users table
class AddResetPasswordFieldsToUsers < ActiveRecord::Migration[7.1]
  def change
    change_table :users, bulk: true do |t|
      t.column :reset_password_token, :string
      t.column :reset_password_sent_at, :datetime
    end
  end
end
