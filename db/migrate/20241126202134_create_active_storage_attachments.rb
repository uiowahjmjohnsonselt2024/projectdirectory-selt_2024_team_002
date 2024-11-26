# db/migrate/20241126202134_create_active_storage_attachments.rb

# frozen_string_literal: true

# This migration creates the active storage attachments table
class CreateActiveStorageAttachments < ActiveRecord::Migration[7.1]
  def change
    create_table 'active_storage_attachments', force: :cascade do |t|
      t.string 'name', null: false
      t.string 'record_type', null: false
      t.bigint 'record_id', null: false
      t.bigint 'blob_id', null: false
      t.datetime 'created_at', null: false
      t.index ['blob_id'], name: 'index_active_storage_attachments_on_blob_id'
      t.index %w[record_type record_id name blob_id], name: 'index_active_storage_attachments_uniqueness', unique: true
    end
  end
end
