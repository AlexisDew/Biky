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

ActiveRecord::Schema.define(version: 2019_03_18_114408) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "bike_equipments", force: :cascade do |t|
    t.bigint "bike_id"
    t.bigint "equipment_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["bike_id"], name: "index_bike_equipments_on_bike_id"
    t.index ["equipment_id"], name: "index_bike_equipments_on_equipment_id"
  end

  create_table "bikes", force: :cascade do |t|
    t.string "color"
    t.bigint "model_id"
    t.bigint "owner_id"
    t.bigint "city_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["city_id"], name: "index_bikes_on_city_id"
    t.index ["model_id"], name: "index_bikes_on_model_id"
    t.index ["owner_id"], name: "index_bikes_on_owner_id"
  end

  create_table "brands", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "cities", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "equipments", force: :cascade do |t|
    t.string "name"
    t.string "logo_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "models", force: :cascade do |t|
    t.string "name"
    t.integer "year"
    t.integer "engine_size"
    t.integer "power"
    t.bigint "brand_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["brand_id"], name: "index_models_on_brand_id"
  end

  create_table "reviews", force: :cascade do |t|
    t.integer "rating"
    t.string "text"
    t.bigint "author_id"
    t.bigint "destinator_id"
    t.date "date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["author_id"], name: "index_reviews_on_author_id"
    t.index ["destinator_id"], name: "index_reviews_on_destinator_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "first_name"
    t.string "last_name"
    t.string "pseudo"
    t.string "about"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "bike_equipments", "bikes"
  add_foreign_key "bike_equipments", "equipments"
  add_foreign_key "bikes", "cities"
  add_foreign_key "bikes", "models"
  add_foreign_key "bikes", "users", column: "owner_id"
  add_foreign_key "models", "brands"
  add_foreign_key "reviews", "users", column: "author_id"
  add_foreign_key "reviews", "users", column: "destinator_id"
end
