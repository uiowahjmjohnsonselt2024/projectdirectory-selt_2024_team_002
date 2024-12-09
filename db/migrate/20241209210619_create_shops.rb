# frozen_string_literal: true

# migration to create the shops table in the database
class CreateShops < ActiveRecord::Migration[7.1]
  def change
    create_table :shops do |t|
      t.string :shop_name
      t.string :description

      t.timestamps
    end
  end
end
