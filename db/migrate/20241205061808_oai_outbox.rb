#reperesents all the create image events that the active job polls from
class OaiOutbox < ActiveRecord::Migration[7.1]
  def change
    create_table :oai_outbox do |t|
      t.integer :world_id, null: false, foreign_key: { to_table: :worlds }
      t.integer :row, null: false
      t.integer :col, null: false
      t.timestamps # created at
    end

    add_check_constraint :oai_outbox, "row < #{World.dim}", name: 'row_less_than_dim'
    add_check_constraint :oai_outbox, "col < #{World.dim}", name: 'col_less_than_dim'
    add_index :oai_outbox, [:world_id]
  end
end
