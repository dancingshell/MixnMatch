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

ActiveRecord::Schema.define(version: 20140915052327) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "artists", force: true do |t|
    t.string   "name"
    t.string   "genre"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "event_artists", force: true do |t|
    t.integer  "artist_id"
    t.integer  "event_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "event_artists", ["artist_id"], name: "index_event_artists_on_artist_id", using: :btree
  add_index "event_artists", ["event_id"], name: "index_event_artists_on_event_id", using: :btree

  create_table "events", force: true do |t|
    t.string   "title"
    t.string   "date"
    t.string   "location"
    t.string   "time"
    t.string   "venue"
    t.string   "url"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "groups", force: true do |t|
    t.integer  "event_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "groups", ["event_id"], name: "index_groups_on_event_id", using: :btree

  create_table "matches", force: true do |t|
    t.integer  "matcher_id"
    t.integer  "matchee_id"
    t.string   "type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "matches", ["matchee_id"], name: "index_matches_on_matchee_id", using: :btree
  add_index "matches", ["matcher_id"], name: "index_matches_on_matcher_id", using: :btree

  create_table "messages", force: true do |t|
    t.integer  "match_id"
    t.string   "content"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "messages", ["match_id"], name: "index_messages_on_match_id", using: :btree

  create_table "user_artists", force: true do |t|
    t.integer  "user_id"
    t.integer  "artist_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "user_artists", ["artist_id"], name: "index_user_artists_on_artist_id", using: :btree
  add_index "user_artists", ["user_id"], name: "index_user_artists_on_user_id", using: :btree

  create_table "user_groups", force: true do |t|
    t.integer  "group_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "user_groups", ["group_id"], name: "index_user_groups_on_group_id", using: :btree
  add_index "user_groups", ["user_id"], name: "index_user_groups_on_user_id", using: :btree

  create_table "users", force: true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.string   "password_digest"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
