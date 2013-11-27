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

ActiveRecord::Schema.define(version: 20131127221852) do

  create_table "author_books", force: true do |t|
    t.integer  "author_id"
    t.integer  "book_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "author_books", ["author_id"], name: "index_author_books_on_author_id"
  add_index "author_books", ["book_id"], name: "index_author_books_on_book_id"

  create_table "authors", force: true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "middle_initial"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "books", force: true do |t|
    t.string   "isbn"
    t.string   "title"
    t.date     "publish_date"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "subtitle"
    t.string   "lcc"
    t.boolean  "restricted"
    t.integer  "quantity",     default: 1
  end

  create_table "checkouts", force: true do |t|
    t.datetime "checked_out_at"
    t.datetime "checked_in_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "patron_id"
    t.integer  "distributor_id"
    t.integer  "book_id"
    t.datetime "due_date"
    t.integer  "distributor_check_in_id"
  end

  add_index "checkouts", ["book_id"], name: "index_checkouts_on_book_id"
  add_index "checkouts", ["distributor_check_in_id"], name: "index_checkouts_on_distributor_check_in_id"
  add_index "checkouts", ["distributor_id"], name: "index_checkouts_on_distributor_id"
  add_index "checkouts", ["patron_id"], name: "index_checkouts_on_patron_id"

  create_table "google_book_data", force: true do |t|
    t.text     "description"
    t.string   "preview_link"
    t.string   "img_thumbnail"
    t.string   "img_small"
    t.string   "img_large"
    t.string   "img_medium"
    t.integer  "book_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "reasons", force: true do |t|
    t.string   "message"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "reservations", force: true do |t|
    t.datetime "reserve_at"
    t.boolean  "fulfilled"
    t.datetime "expires_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.integer  "book_id"
  end

  add_index "reservations", ["book_id"], name: "index_reservations_on_book_id"
  add_index "reservations", ["user_id"], name: "index_reservations_on_user_id"

  create_table "roles", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "strikes", force: true do |t|
    t.string   "other_info"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "patron_id"
    t.integer  "distributor_id"
    t.integer  "reason_id"
  end

  add_index "strikes", ["distributor_id"], name: "index_strikes_on_distributor_id"
  add_index "strikes", ["patron_id"], name: "index_strikes_on_patron_id"
  add_index "strikes", ["reason_id"], name: "index_strikes_on_reason_id"

  create_table "users", force: true do |t|
    t.string   "user_name"
    t.boolean  "banned"
    t.datetime "created_at"
    t.datetime "updated_at"
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
    t.integer  "role_id"
    t.string   "barcode_hash"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  add_index "users", ["role_id"], name: "index_users_on_role_id"

end
