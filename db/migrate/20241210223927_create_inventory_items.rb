class CreateInventoryItems < ActiveRecord::Migration[7.1]
  def change
    create_table :inventory_items do |t|
      t.bigint :user_world_id
      t.bigint :item_id
      t.integer :amount_available

      t.timestamps
    end
  end
end
