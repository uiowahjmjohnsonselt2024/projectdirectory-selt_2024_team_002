# frozen_string_literal: true

class AddImageUrlToGridsquares < ActiveRecord::Migration[7.1]
  def change
    add_column :gridsquares, :image_url, :string
  end
end
