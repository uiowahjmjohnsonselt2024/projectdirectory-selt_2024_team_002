#reperesents all the create image events that the active job polls from
class OaiOutbox < ActiveRecord::Migration[7.1]
  def change
    create_table :openai_events do |t|
      t.references :world, null: false, foreign_key: true
      t.integer :row, null: false
      t.integer :col, null: false
      t.timestamps # created at
    end

    
  end
end
