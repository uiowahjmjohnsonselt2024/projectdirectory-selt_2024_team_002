# frozen_string_literal: true

class AddMessage < ActiveRecord::Migration[7.0]
  def change
    create_table :messages do |t|
      t.references :world, null: false, foreign_key: true, dependent: :destroy
      t.references :user, null: false, foreign_key: true, dependent: :destroy
      t.text :message, null: false
      t.timestamps
    end

  end
end
