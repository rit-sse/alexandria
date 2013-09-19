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

ActiveRecord::Schema.define(version: 20130919215833) do

  create_table "authors", force: true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "middle_initial"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  create_table "authors_books", id: false, force: true do |t|
    t.integer "author_id"
    t.integer "book_id"
  end

  create_table "books", force: true do |t|
    t.string   "ISBN"
    t.string   "title"
    t.date     "publish_date"
    t.string   "UUID"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.integer  "checkout_id"
    t.string   "subtitle"
    t.string   "LCC"
  end

  create_table "checkouts", force: true do |t|
    t.datetime "checked_out_at"
    t.datetime "checked_in_at"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.integer  "patron_id"
    t.integer  "distributor_id"
  end

  create_table "google_book_data", force: true do |t|
    t.text     "description"
    t.string   "preview_link"
    t.string   "img_thumbnail"
    t.string   "img_small"
    t.string   "img_large"
    t.string   "img_medium"
    t.integer  "book_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  create_table "reservations", force: true do |t|
    t.datetime "reserve_at"
    t.boolean  "fuffiled"
    t.datetime "expires_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "user_id"
    t.integer  "book_id"
  end

  create_table "strikes", force: true do |t|
    t.string   "message"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: true do |t|
    t.string   "user_name"
    t.boolean  "banned"
    t.string   "role"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

end
