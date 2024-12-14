class AddSpeedBoostToUserWorld < ActiveRecord::Migration[7.1]
  def change
    add_column :user_worlds, :speed_boost, :boolean, default: false
    add_column :user_worlds, :speed_boost_count, :integer, default: 0
  end
end
