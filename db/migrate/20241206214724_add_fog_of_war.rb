class AddFogOfWar < ActiveRecord::Migration[7.1]
  def change
    add_column :user_worlds, :seen, :string, array: true, default: []
  end
end
