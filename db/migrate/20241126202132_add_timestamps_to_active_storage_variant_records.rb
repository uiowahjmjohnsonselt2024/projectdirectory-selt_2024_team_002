# frozen_string_literal: true

# This migration adds timestamps to the active_storage_variant_records table
class AddTimestampsToActiveStorageVariantRecords < ActiveRecord::Migration[7.1]
  def change
    change_table :active_storage_variant_records, bulk: true, &:timestamps
  end
end
