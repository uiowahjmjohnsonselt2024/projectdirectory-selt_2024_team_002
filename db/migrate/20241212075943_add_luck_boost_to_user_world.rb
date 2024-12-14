class AddLuckBoostToUserWorld < ActiveRecord::Migration[7.1]
  def change
    add_column :user_worlds, :luck_boost, :boolean, default: false
    add_column :user_worlds, :luck_boost_count, :integer, default: 0
  end
end
