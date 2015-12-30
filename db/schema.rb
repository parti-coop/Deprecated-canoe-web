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

ActiveRecord::Schema.define(version: 20151230013906) do

  create_table "canoes", force: :cascade do |t|
    t.string   "title",      null: false
    t.integer  "user_id",    null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text     "theme"
    t.string   "slug",       null: false
    t.string   "logo"
    t.string   "cover"
  end

  add_index "canoes", ["slug"], name: "index_canoes_on_slug", unique: true
  add_index "canoes", ["user_id"], name: "index_canoes_on_user_id"

  create_table "crews", force: :cascade do |t|
    t.integer  "user_id",    null: false
    t.integer  "inviter_id", null: false
    t.integer  "canoe_id",   null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "crews", ["canoe_id"], name: "index_crews_on_canoe_id"
  add_index "crews", ["inviter_id"], name: "index_crews_on_inviter_id"
  add_index "crews", ["user_id", "canoe_id"], name: "index_crews_on_user_id_and_canoe_id", unique: true

  create_table "discussions", force: :cascade do |t|
    t.string   "subject",    null: false
    t.text     "body"
    t.integer  "user_id",    null: false
    t.integer  "canoe_id",   null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "discussions", ["canoe_id"], name: "index_discussions_on_canoe_id"
  add_index "discussions", ["user_id"], name: "index_discussions_on_user_id"

  create_table "opinions", force: :cascade do |t|
    t.text     "body"
    t.integer  "discussion_id", null: false
    t.integer  "user_id",       null: false
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.boolean  "pinned"
    t.datetime "pinned_at"
  end

  add_index "opinions", ["discussion_id"], name: "index_opinions_on_discussion_id"
  add_index "opinions", ["user_id"], name: "index_opinions_on_user_id"

  create_table "proposals", force: :cascade do |t|
    t.text     "body"
    t.integer  "discussion_id", null: false
    t.integer  "user_id",       null: false
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "proposals", ["discussion_id"], name: "index_proposals_on_discussion_id"
  add_index "proposals", ["user_id"], name: "index_proposals_on_user_id"

  create_table "users", force: :cascade do |t|
    t.string   "email",      null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "nickname",   null: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["nickname"], name: "index_users_on_nickname", unique: true

  create_table "votes", force: :cascade do |t|
    t.integer  "proposal_id", null: false
    t.integer  "user_id",     null: false
    t.integer  "choice",      null: false
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "votes", ["proposal_id"], name: "index_votes_on_proposal_id"
  add_index "votes", ["user_id"], name: "index_votes_on_user_id"

end
