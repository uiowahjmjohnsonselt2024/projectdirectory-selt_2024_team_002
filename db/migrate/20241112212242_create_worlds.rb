class CreateWorlds < ActiveRecord::Migration
  def change
    create_table :worlds do |t|
      t.string :world_code
      t.string :world_name
      t.string :user_id
      t.boolean :is_public
      t.string :max_player
      t.text :data
      t.timestamps null: false
    end
  end
end
