class CreateShopsItems < ActiveRecord::Migration[7.1]
  def change
    create_table :shops_items do |t|
      t.bigint :shop_id
      t.bigint :item_id
      t.integer :amount_available

      t.timestamps
    end
  end
end
