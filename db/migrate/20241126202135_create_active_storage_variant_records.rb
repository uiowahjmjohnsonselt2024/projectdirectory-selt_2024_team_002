# db/migrate/20241126202134_create_active_storage_variant_records.rb

# frozen_string_literal: true

# This migration creates the active storage variant records table
class CreateActiveStorageVariantRecords < ActiveRecord::Migration[7.1]
  def change
    create_table 'active_storage_variant_records', force: :cascade do |t|
      t.bigint 'blob_id', null: false
      t.string 'variation_digest', null: false
      t.datetime 'created_at', null: false
      t.datetime 'updated_at', null: false
      t.index %w[blob_id variation_digest], name: 'index_active_storage_variant_records_uniqueness', unique: true
    end
  end
end
