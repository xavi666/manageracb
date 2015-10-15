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

ActiveRecord::Schema.define(:version => 20151015121059) do

  create_table "players", :force => true do |t|
    t.string   "name"
    t.integer  "age"
    t.date     "date_of_birth"
    t.integer  "team_id"
    t.boolean  "active",        :default => true
    t.datetime "created_at",                      :null => false
    t.datetime "updated_at",                      :null => false
  end

  create_table "statistics", :force => true do |t|
    t.integer  "player_id"
    t.integer  "team_id"
    t.integer  "number"
    t.integer  "seconds"
    t.integer  "points"
    t.integer  "two_p"
    t.integer  "two_pm"
    t.integer  "three_p"
    t.integer  "three_pm"
    t.integer  "one_p"
    t.integer  "one_pm"
    t.integer  "rebounds"
    t.integer  "orebounds"
    t.integer  "drebounds"
    t.integer  "assists"
    t.integer  "steals"
    t.integer  "turnovers"
    t.integer  "fastbreaks"
    t.integer  "mblocks"
    t.integer  "rbllocks"
    t.integer  "mfaults"
    t.integer  "rfaults"
    t.integer  "positive_negative"
    t.integer  "value"
    t.boolean  "active",            :default => true
    t.datetime "created_at",                          :null => false
    t.datetime "updated_at",                          :null => false
  end

  create_table "teams", :force => true do |t|
    t.string   "name"
    t.boolean  "active",     :default => true
    t.datetime "created_at",                   :null => false
    t.datetime "updated_at",                   :null => false
  end

end
