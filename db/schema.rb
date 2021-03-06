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

ActiveRecord::Schema.define(version: 20150706210918) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "tickets", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "key"
    t.string   "uid"
    t.string   "displayname"
    t.string   "skill"
    t.boolean  "served"
    t.string   "progress"
    t.string   "useragent"
    t.integer  "user_id"
    t.string   "cr_id"
    t.string   "cr_title"
    t.string   "cr_status"
    t.string   "cr_webm_duration"
    t.string   "cr_webm_s3url"
    t.string   "cr_mp4_duration"
    t.string   "cr_mp4_s3url"
    t.string   "cr_vb_state"
    t.string   "cr_vb_fileurl"
    t.string   "ipaddress"
  end

  add_index "tickets", ["user_id"], name: "index_tickets_on_user_id", using: :btree

  create_table "users", force: true do |t|
    t.string   "name"
    t.string   "hashed_password"
    t.string   "salt"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
