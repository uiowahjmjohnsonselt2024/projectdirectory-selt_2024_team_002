class CreateQuests < ActiveRecord::Migration[6.1]
  def change
    create_table :quests do |t|
      t.integer :cell_row
      t.integer :cell_col
      t.boolean :completed, default: false
      t.references :user_world, foreign_key: true
      t.references :world, foreign_key: true

      t.timestamps
    end
  end
end