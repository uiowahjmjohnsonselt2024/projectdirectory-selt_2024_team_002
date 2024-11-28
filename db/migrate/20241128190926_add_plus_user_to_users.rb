class AddPlusUserToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :plus_user, :boolean
  end
end
