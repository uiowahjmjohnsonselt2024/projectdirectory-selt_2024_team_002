# frozen_string_literal: true

# This migration creates the active storage blobs table
class CreateActiveStorageBlobs < ActiveRecord::Migration[7.1]
  def change
    create_active_storage_blobs_table
  end

  private

  def create_active_storage_blobs_table
    create_table 'active_storage_blobs', force: :cascade do |t|
      t.timestamps
      add_columns_to_active_storage_blobs(t)
      t.index ['key'], name: 'index_active_storage_blobs_on_key', unique: true
    end
  end

  def add_columns_to_active_storage_blobs(table)
    table.string 'key', null: false
    table.string 'filename', null: false
    table.string 'content_type'
    table.text 'metadata'
    table.string 'service_name', null: false
    table.bigint 'byte_size', null: false
    table.string 'checksum'
    table.datetime 'created_at', null: false
  end
end
