# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20160402053716) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "blolol_user_data", force: :cascade do |t|
    t.integer  "user_id",                             null: false
    t.string   "blolol_id",  limit: 255,              null: false
    t.string   "roles",      limit: 255, default: [],              array: true
    t.string   "username",   limit: 255,              null: false
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

  add_index "blolol_user_data", ["user_id"], name: "index_blolol_user_data_on_user_id", unique: true, using: :btree

  create_table "characters", force: :cascade do |t|
    t.string   "name",                      null: false
    t.integer  "level",         default: 1, null: false
    t.string   "role",                      null: false
    t.integer  "user_id",                   null: false
    t.integer  "xp",            default: 0, null: false
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.integer  "xp_penalty",    default: 0, null: false
    t.datetime "last_level_at"
  end

  add_index "characters", ["name"], name: "index_characters_on_name", unique: true, using: :btree
  add_index "characters", ["user_id"], name: "index_characters_on_user_id", using: :btree

  create_table "effects", force: :cascade do |t|
    t.integer  "character_id", null: false
    t.string   "type",         null: false
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "effects", ["character_id"], name: "index_effects_on_character_id", using: :btree

  create_table "items", force: :cascade do |t|
    t.integer "character_id",             null: false
    t.integer "level",                    null: false
    t.string  "name",         limit: 255, null: false
    t.string  "rarity",       limit: 255, null: false
    t.string  "slot",         limit: 255, null: false
  end

  add_index "items", ["character_id"], name: "index_items_on_character_id", using: :btree

  create_table "sessions", force: :cascade do |t|
    t.integer  "character_id", null: false
    t.integer  "user_id",      null: false
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "sessions", ["character_id"], name: "index_sessions_on_character_id", using: :btree
  add_index "sessions", ["user_id"], name: "index_sessions_on_user_id", unique: true, using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "name",       null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "users", ["name"], name: "index_users_on_name", unique: true, using: :btree

end
