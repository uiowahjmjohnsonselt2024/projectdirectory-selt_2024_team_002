class AddGridsquares < ActiveRecord::Migration[7.1]
  def change
    create_table :gridsquares do |t|
      t.references :world, foreign_key: true
      t.integer :row
      t.integer :col
      t.boolean :filled
      t.timestamps
    end
  end
end
