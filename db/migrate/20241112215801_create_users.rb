class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :email
      t.text :password_hash
      t.text :session_token
      t.integer :available_credits
      t.string :display_name

      t.timestamps null: false
    end
    add_index :users, :session_token, unique: true
    add_index :users, :display_name, unique: true
  end
end
