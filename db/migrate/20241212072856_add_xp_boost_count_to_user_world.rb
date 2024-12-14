class AddXpBoostCountToUserWorld < ActiveRecord::Migration[7.1]
  def change
    add_column :user_worlds, :xp_boost_count, :integer, default: 0
  end
end
