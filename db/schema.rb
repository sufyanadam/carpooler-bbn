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

ActiveRecord::Schema.define(:version => 20121204211857) do

  create_table "destination_spots", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "drivers", :force => true do |t|
    t.decimal  "current_lat"
    t.decimal  "current_lng"
    t.datetime "last_seen_at"
    t.decimal  "last_seen_lat"
    t.decimal  "last_seen_lng"
    t.decimal  "distance_moved_since_last_seen"
    t.string   "available_for"
    t.integer  "pickup_spot_id"
    t.integer  "destination_spot_id"
    t.string   "type"
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
  end

  create_table "pickup_spots", :force => true do |t|
    t.string   "name"
    t.decimal  "lat"
    t.decimal  "lng"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "riders", :force => true do |t|
    t.decimal  "current_lat"
    t.decimal  "current_lng"
    t.datetime "last_seen_at"
    t.decimal  "last_seen_lat"
    t.decimal  "last_seen_lng"
    t.decimal  "distance_moved_since_last_seen"
    t.string   "available_for"
    t.integer  "reserving_driver_id"
    t.integer  "pickup_spot_id"
    t.integer  "destination_spot_id"
    t.string   "type"
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
  end

end
