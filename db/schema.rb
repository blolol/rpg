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

ActiveRecord::Schema.define(version: 20160319034342) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "characters", force: :cascade do |t|
    t.string   "name",                   null: false
    t.integer  "level",      default: 1, null: false
    t.string   "role",                   null: false
    t.integer  "user_id",                null: false
    t.integer  "xp",         default: 0, null: false
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "characters", ["name"], name: "index_characters_on_name", unique: true, using: :btree
  add_index "characters", ["user_id"], name: "index_characters_on_user_id", using: :btree

  create_table "sessions", force: :cascade do |t|
    t.integer  "character_id", null: false
    t.integer  "user_id",      null: false
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "sessions", ["character_id"], name: "index_sessions_on_character_id", using: :btree
  add_index "sessions", ["user_id"], name: "index_sessions_on_user_id", unique: true, using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "name",                       null: false
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.json     "blolol_metadata"
    t.datetime "blolol_metadata_updated_at"
  end

  add_index "users", ["name"], name: "index_users_on_name", unique: true, using: :btree

end
