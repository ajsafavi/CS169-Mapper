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

ActiveRecord::Schema.define(version: 20151017215654) do

  create_table "columns", force: :cascade do |t|
    t.integer  "dataset_id"
    t.string   "name"
    t.string   "column_type"
    t.string   "null_value"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "columns", ["dataset_id"], name: "index_columns_on_dataset_id"

  create_table "datasets", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "name"
    t.string   "filepath"
    t.string   "location_column"
    t.string   "weight_column"
    t.string   "location_type"
    t.integer  "num_rows"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_index "datasets", ["user_id"], name: "index_datasets_on_user_id"

  create_table "maps", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "dataset_id"
    t.string   "name"
    t.string   "shareable_url"
    t.string   "display_variable"
    t.string   "filter_variable"
    t.string   "styling"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  add_index "maps", ["dataset_id"], name: "index_maps_on_dataset_id"
  add_index "maps", ["shareable_url"], name: "index_maps_on_shareable_url"
  add_index "maps", ["user_id"], name: "index_maps_on_user_id"

  create_table "users", force: :cascade do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
