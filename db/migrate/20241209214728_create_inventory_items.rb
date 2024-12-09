# frozen_string_literal: true

# migration to create the inventory_items table
class CreateInventoryItems < ActiveRecord::Migration[7.1]
  def change
    create_table :inventory_items do |t|
      t.references :user_world, foreign_key: true
      t.references :item, foreign_key: true
      t.integer :amount_available

      t.timestamps
    end
  end
end
