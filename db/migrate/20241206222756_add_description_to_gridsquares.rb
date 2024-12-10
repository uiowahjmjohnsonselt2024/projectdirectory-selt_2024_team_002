class AddDescriptionToGridsquares < ActiveRecord::Migration[7.1]
  def change
    add_column :gridsquares, :description, :string
  end
end
