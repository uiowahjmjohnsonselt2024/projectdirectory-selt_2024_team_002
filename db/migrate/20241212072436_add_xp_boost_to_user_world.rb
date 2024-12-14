class AddXpBoostToUserWorld < ActiveRecord::Migration[7.1]
  def change
    add_column :user_worlds, :xp_boost, :float, default: 1.0
  end
end
