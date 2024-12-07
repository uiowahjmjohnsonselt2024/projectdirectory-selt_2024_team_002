class AddUserPosition < ActiveRecord::Migration[7.1]
  def change
    add_column :user_worlds, :user_row, :int, default: 1
    add_column :user_worlds, :user_col, :int, default: 1
  end
end
