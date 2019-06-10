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

ActiveRecord::Schema.define(version: 0) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "bookings", id: :serial, force: :cascade do |t|
    t.integer "trip_id"
    t.integer "stop_id"
    t.integer "user_id"
  end

  create_table "stops", id: :serial, force: :cascade do |t|
    t.string "name", limit: 256
    t.string "address", limit: 512
    t.string "lat_long", limit: 256
  end

  create_table "trips", id: :serial, force: :cascade do |t|
    t.string "name", limit: 128, null: false
    t.integer "user_id"
  end

  create_table "users", id: :serial, force: :cascade do |t|
    t.string "username", limit: 128, null: false
    t.string "password_digest", limit: 256, null: false
    t.string "image", limit: 1024
  end

  add_foreign_key "bookings", "stops", name: "bookings_stop_id_fkey", on_delete: :cascade
  add_foreign_key "bookings", "trips", name: "bookings_trip_id_fkey", on_delete: :cascade
  add_foreign_key "bookings", "users", name: "bookings_user_id_fkey", on_delete: :cascade
  add_foreign_key "trips", "users", name: "trips_user_id_fkey", on_delete: :cascade
end
