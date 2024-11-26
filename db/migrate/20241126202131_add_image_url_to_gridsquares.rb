# frozen_string_literal: true

# Adds image_url column to gridsquares table
class AddImageUrlToGridsquares < ActiveRecord::Migration[7.1]
  def change
    add_column :gridsquares, :image_url, :string
  end
end
