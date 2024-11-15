# frozen_string_literal: true

# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20_241_115_120_951) do
  create_table 'grids', force: :cascade do |t|
    t.text     'data', default: '[]'
    t.datetime 'created_at'
    t.datetime 'updated_at'
  end

  create_table 'users', force: :cascade do |t|
    t.string   'email'
    t.text     'password_digest'
    t.text     'session_token'
    t.integer  'available_credits'
    t.string   'display_name'
    t.datetime 'created_at',        null: false
    t.datetime 'updated_at',        null: false
  end

  add_index 'users', ['display_name'], name: 'index_users_on_display_name', unique: true
  add_index 'users', ['session_token'], name: 'index_users_on_session_token', unique: true,
                                        where: 'session_token IS NOT NULL'

  create_table 'worlds', force: :cascade do |t|
    t.string   'world_code'
    t.string   'world_name'
    t.string   'user_id'
    t.boolean  'is_public'
    t.string   'max_player'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.text     'data'
  end
end
