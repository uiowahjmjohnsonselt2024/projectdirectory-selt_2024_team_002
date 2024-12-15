class CreateItems < ActiveRecord::Migration[7.1]
  def change
    create_table :items do |t|
      t.string :item_name
      t.string :description
      t.float :price
      t.boolean :is_interactable

      t.timestamps
    end
  end
end
