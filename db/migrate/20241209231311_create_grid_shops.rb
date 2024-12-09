class CreateGridShops < ActiveRecord::Migration[7.1]
  def change
    create_table :grid_shops do |t|
      t.references :gridsquare, foreign_key: true
      t.references :shop, foreign_key: true

      t.timestamps
    end
  end
end
