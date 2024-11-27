# frozen_string_literal: true

# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.
# rubocop:disable Metrics/BlockLength

ActiveRecord::Schema[7.1].define(version: 20_241_124_021_748) do
  # These are extensions that must be enabled in order to support this database
  enable_extension 'plpgsql'

  create_table 'active_storage_attachments', force: :cascade do |t|
    t.string 'name', null: false
    t.string 'record_type', null: false
    t.bigint 'record_id', null: false
    t.bigint 'blob_id', null: false
    t.datetime 'created_at', null: false
    t.index ['blob_id'], name: 'index_active_storage_attachments_on_blob_id'
    t.index %w[record_type record_id name blob_id], name: 'index_active_storage_attachments_uniqueness',
                                                    unique: true
  end

  create_table 'active_storage_blobs', force: :cascade do |t|
    t.string 'key', null: false
    t.string 'filename', null: false
    t.string 'content_type'
    t.text 'metadata'
    t.string 'service_name', null: false
    t.bigint 'byte_size', null: false
    t.string 'checksum'
    t.datetime 'created_at', null: false
    t.index ['key'], name: 'index_active_storage_blobs_on_key', unique: true
  end

  create_table 'active_storage_variant_records', force: :cascade do |t|
    t.bigint 'blob_id', null: false
    t.string 'variation_digest', null: false
    t.index %w[blob_id variation_digest], name: 'index_active_storage_variant_records_uniqueness', unique: true
    t.datetime 'created_at', null: false
  end

  create_table 'gridsquares', force: :cascade do |t|
    t.bigint 'world_id'
    t.integer 'row'
    t.integer 'col'
    t.boolean 'filled'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['world_id'], name: 'index_gridsquares_on_world_id'
  end

  create_table 'users', force: :cascade do |t|
    t.string 'email'
    t.text 'password_digest'
    t.text 'session_token'
    t.integer 'available_credits'
    t.string 'display_name'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['display_name'], name: 'index_users_on_display_name', unique: true
    t.index ['session_token'], name: 'index_users_on_session_token', unique: true, where: '(session_token IS NOT NULL)'
  end

  create_table 'worlds', force: :cascade do |t|
    t.string 'world_code'
    t.string 'world_name'
    t.bigint 'user_id_id'
    t.boolean 'is_public'
    t.string 'max_player'
    t.text 'data'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['user_id_id'], name: 'index_worlds_on_user_id_id'
  end

  add_foreign_key 'active_storage_attachments', 'active_storage_blobs', column: 'blob_id'
  add_foreign_key 'active_storage_variant_records', 'active_storage_blobs', column: 'blob_id'
  add_foreign_key 'gridsquares', 'worlds'
end

# rubocop:enable Metrics/BlockLength
