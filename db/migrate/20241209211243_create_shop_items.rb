# frozen_string_literal: true

# migration to create the shop_items table in the database
class CreateShopItems < ActiveRecord::Migration[7.1]
  def change
    create_table :shop_items do |t|
      t.references :shop, foreign_key: true
      t.references :item, foreign_key: true
      t.integer :amount_available

      t.timestamps
    end
  end
end
