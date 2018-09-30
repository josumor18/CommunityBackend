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

ActiveRecord::Schema.define(version: 20180930143930) do

  create_table "comments", force: :cascade do |t|
    t.integer  "id_news"
    t.integer  "id_user"
    t.string   "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "communities", force: :cascade do |t|
    t.string   "name"
    t.string   "description"
    t.string   "rules"
    t.boolean  "isSubcommunity"
    t.string   "photo"
    t.string   "photo_thumbnail"
    t.integer  "sub_communities"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  create_table "community_members", force: :cascade do |t|
    t.integer  "id_community"
    t.integer  "id_user"
    t.boolean  "isAdmin"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "events", force: :cascade do |t|
    t.integer  "id_community"
    t.string   "title"
    t.string   "description"
    t.date     "dateEvent"
    t.time     "start"
    t.time     "end"
    t.string   "photo"
    t.boolean  "approved"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "favorites", force: :cascade do |t|
    t.integer  "id_user"
    t.integer  "id_news"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "news", force: :cascade do |t|
    t.integer  "idCommunity"
    t.string   "title"
    t.string   "description"
    t.datetime "date"
    t.string   "photo"
    t.boolean  "approved"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "notifications", force: :cascade do |t|
    t.integer  "idUser"
    t.integer  "idContent"
    t.datetime "created_at",   null: false
    t.boolean  "isNews"
    t.boolean  "isReports"
    t.boolean  "isEvents"
    t.string   "titleContent"
    t.boolean  "seen"
    t.datetime "updated_at",   null: false
  end

  create_table "reports", force: :cascade do |t|
    t.integer  "id_comment"
    t.integer  "id_user"
    t.string   "reason"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "requests", force: :cascade do |t|
    t.integer  "id_community"
    t.integer  "id_user"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.boolean  "seen"
  end

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.string   "email"
    t.string   "password"
    t.string   "cel"
    t.string   "tel"
    t.string   "address"
    t.string   "photo"
    t.string   "photo_thumbnail"
    t.boolean  "isPrivate"
    t.string   "auth_token"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

end
