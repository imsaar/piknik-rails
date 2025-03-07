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

ActiveRecord::Schema[7.0].define(version: 2025_03_07_181345) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "dishes", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.integer "quantity_needed"
    t.integer "quantity_signed_up"
    t.bigint "event_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["event_id"], name: "index_dishes_on_event_id"
  end

  create_table "events", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.datetime "date"
    t.string "location"
    t.string "code"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "theme"
  end

  create_table "participant_signups", force: :cascade do |t|
    t.bigint "potluck_item_id", null: false
    t.string "email", null: false
    t.string "name"
    t.integer "quantity", default: 1
    t.string "confirmation_uuid", null: false
    t.boolean "confirmed", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["confirmation_uuid"], name: "index_participant_signups_on_confirmation_uuid", unique: true
    t.index ["potluck_item_id"], name: "index_participant_signups_on_potluck_item_id"
  end

  create_table "potluck_events", force: :cascade do |t|
    t.string "name", null: false
    t.date "event_date", null: false
    t.string "theme"
    t.string "admin_email", null: false
    t.string "admin_name"
    t.string "admin_uuid", null: false
    t.string "participant_uuid", null: false
    t.boolean "email_notifications", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["admin_uuid"], name: "index_potluck_events_on_admin_uuid", unique: true
    t.index ["participant_uuid"], name: "index_potluck_events_on_participant_uuid", unique: true
  end

  create_table "potluck_items", force: :cascade do |t|
    t.bigint "potluck_event_id", null: false
    t.string "name", null: false
    t.integer "quantity_needed", default: 1
    t.integer "quantity_signed_up", default: 0
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["potluck_event_id"], name: "index_potluck_items_on_potluck_event_id"
  end

  create_table "potluck_signups", force: :cascade do |t|
    t.bigint "potluck_item_id", null: false
    t.string "email"
    t.string "name"
    t.integer "quantity"
    t.boolean "confirmed"
    t.string "confirmation_token"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["potluck_item_id"], name: "index_potluck_signups_on_potluck_item_id"
  end

  create_table "signups", force: :cascade do |t|
    t.bigint "dish_id", null: false
    t.string "participant_name"
    t.string "participant_email"
    t.integer "quantity"
    t.boolean "confirmed"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["dish_id"], name: "index_signups_on_dish_id"
  end

  add_foreign_key "dishes", "events"
  add_foreign_key "participant_signups", "potluck_items"
  add_foreign_key "potluck_items", "potluck_events"
  add_foreign_key "potluck_signups", "potluck_items"
  add_foreign_key "signups", "dishes"
end
