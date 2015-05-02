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

ActiveRecord::Schema.define(version: 20150501202614) do

  create_table "portfolios", force: true do |t|
    t.string   "name"
    t.float    "initial_cash"
    t.string   "benchmark"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sessions", force: true do |t|
    t.string   "session_id", null: false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], name: "index_sessions_on_session_id", unique: true
  add_index "sessions", ["updated_at"], name: "index_sessions_on_updated_at"

  create_table "stock_data", force: true do |t|
    t.date     "date"
    t.integer  "stock_id"
    t.float    "open"
    t.float    "close"
    t.integer  "volume"
    t.float    "high"
    t.float    "low"
    t.float    "dividend"
    t.float    "split"
    t.float    "adj_open"
    t.float    "adj_high"
    t.float    "adj_low"
    t.float    "adj_close"
    t.float    "adj_volume"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "stock_data", ["stock_id"], name: "index_stock_data_on_stock_id"

  create_table "stocks", force: true do |t|
    t.string   "ticker"
    t.string   "industry_group"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "trades", force: true do |t|
    t.integer  "portfolio_id"
    t.datetime "execution_date"
    t.string   "asset_ticker"
    t.float    "price"
    t.float    "quantity"
    t.float    "fees"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "industry_group"
  end

  add_index "trades", ["portfolio_id"], name: "index_trades_on_portfolio_id"

  create_table "users", force: true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "password_digest"
    t.string   "salt"
    t.string   "login"
  end

end
