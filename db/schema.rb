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

ActiveRecord::Schema.define(version: 20151018203041) do

  create_table "games", force: true do |t|
    t.integer  "local_team_id"
    t.integer  "visitant_team_id"
    t.integer  "local_score"
    t.integer  "visitant_score"
    t.datetime "date_time"
    t.string   "place"
    t.string   "referees"
    t.string   "p1"
    t.string   "p2"
    t.string   "p3"
    t.string   "p4"
    t.boolean  "active",           default: true
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "players", force: true do |t|
    t.string   "name"
    t.date     "date_of_birth"
    t.integer  "team_id"
    t.integer  "number"
    t.integer  "position"
    t.string   "nationality"
    t.boolean  "active",        default: true
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "statistics", force: true do |t|
    t.integer  "player_id"
    t.integer  "team_id"
    t.integer  "team_against_id"
    t.integer  "game_number"
    t.string   "seasson"
    t.integer  "number"
    t.integer  "seconds",           default: 0
    t.integer  "points",            default: 0
    t.integer  "two_p",             default: 0
    t.integer  "two_pm",            default: 0
    t.integer  "three_p",           default: 0
    t.integer  "three_pm",          default: 0
    t.integer  "one_p",             default: 0
    t.integer  "one_pm",            default: 0
    t.integer  "rebounds",          default: 0
    t.integer  "orebounds",         default: 0
    t.integer  "drebounds",         default: 0
    t.integer  "assists",           default: 0
    t.integer  "steals",            default: 0
    t.integer  "turnovers",         default: 0
    t.integer  "fastbreaks",        default: 0
    t.integer  "mblocks",           default: 0
    t.integer  "rblocks",           default: 0
    t.integer  "mfaults",           default: 0
    t.integer  "rfaults",           default: 0
    t.integer  "positive_negative", default: 0
    t.integer  "value",             default: 0
    t.boolean  "active",            default: true
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "teams", force: true do |t|
    t.string   "name"
    t.boolean  "active",     default: true
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
