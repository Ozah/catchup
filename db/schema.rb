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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130403154707) do

  create_table "handshakes", :force => true do |t|
    t.integer  "user_id"
    t.integer  "meeting_id"
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
    t.boolean  "validated",  :default => false
  end

  add_index "handshakes", ["meeting_id"], :name => "index_handshakes_on_meeting_id"
  add_index "handshakes", ["user_id"], :name => "index_handshakes_on_user_id"

  create_table "infos", :force => true do |t|
    t.string   "content"
    t.integer  "user_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "info_type"
  end

  add_index "infos", ["user_id"], :name => "index_infos_on_user_id"

  create_table "meetings", :force => true do |t|
    t.float    "latitude"
    t.float    "longitude"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "venue_id"
  end

  create_table "notes", :force => true do |t|
    t.string   "content"
    t.integer  "user_id"
    t.integer  "meeting_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "places", :force => true do |t|
    t.integer  "user_id"
    t.integer  "venue_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "relationships", :force => true do |t|
    t.integer  "user_id"
    t.integer  "contact_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "relationships", ["contact_id"], :name => "index_relationships_on_contact_id"
  add_index "relationships", ["user_id", "contact_id"], :name => "index_relationships_on_user_id_and_contact_id", :unique => true
  add_index "relationships", ["user_id"], :name => "index_relationships_on_user_id"

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
    t.string   "password_digest"
    t.string   "remember_token"
    t.boolean  "admin",           :default => false
    t.float    "latitude"
    t.float    "longitude"
    t.datetime "location_time"
    t.string   "address"
  end

  add_index "users", ["email"], :name => "index_users_on_email"
  add_index "users", ["remember_token"], :name => "index_users_on_remember_token"

  create_table "venues", :force => true do |t|
    t.string   "foursquare_id"
    t.string   "name"
    t.text     "location"
    t.text     "icon"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.float    "latitude"
    t.float    "longitude"
  end

  add_index "venues", ["foursquare_id"], :name => "index_venues_on_foursquare_id"

end
