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

ActiveRecord::Schema[7.2].define(version: 2025_07_04_102703) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "rides", force: :cascade do |t|
    t.string "from_parking_id"
    t.string "to_parking_id"
    t.float "distance_covered"
    t.integer "journey_time"
    t.float "carbon_emission"
    t.bigint "user_id", null: false
    t.bigint "vehicle_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_rides_on_user_id"
    t.index ["vehicle_id"], name: "index_rides_on_vehicle_id"
  end

  create_table "transactions", force: :cascade do |t|
    t.bigint "ride_id", null: false
    t.decimal "amount_paid"
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["ride_id"], name: "index_transactions_on_ride_id"
    t.index ["user_id"], name: "index_transactions_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "type"
    t.string "email"
    t.string "first_name"
    t.string "last_name"
    t.string "password_digest"
    t.decimal "wallet_balance"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "vehicle_prices", force: :cascade do |t|
    t.string "vehicle_type"
    t.decimal "price"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "vehicles", force: :cascade do |t|
    t.string "model"
    t.string "number"
    t.string "vehicle_type"
    t.string "fuel_type"
    t.float "carbon_footprint"
    t.string "parking_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "state"
    t.index ["parking_id"], name: "index_vehicles_on_parking_id"
  end

  add_foreign_key "rides", "users"
  add_foreign_key "rides", "vehicles"
  add_foreign_key "transactions", "rides"
  add_foreign_key "transactions", "users"
end
