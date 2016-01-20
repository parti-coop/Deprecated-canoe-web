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

ActiveRecord::Schema.define(version: 20160120055324) do

  create_table "canoes", force: :cascade do |t|
    t.string   "title",             null: false
    t.integer  "user_id",           null: false
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.text     "theme"
    t.string   "slug",              null: false
    t.string   "logo"
    t.string   "cover"
    t.string   "slack_webhook_url"
    t.datetime "deleted_at"
  end

  add_index "canoes", ["deleted_at"], name: "index_canoes_on_deleted_at"
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
    t.string   "subject",      null: false
    t.integer  "user_id",      null: false
    t.integer  "canoe_id",     null: false
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.text     "decision"
    t.datetime "discussed_at", null: false
  end

  add_index "discussions", ["canoe_id"], name: "index_discussions_on_canoe_id"
  add_index "discussions", ["user_id"], name: "index_discussions_on_user_id"

  create_table "mailboxer_conversation_opt_outs", force: :cascade do |t|
    t.integer "unsubscriber_id"
    t.string  "unsubscriber_type"
    t.integer "conversation_id"
  end

  add_index "mailboxer_conversation_opt_outs", ["conversation_id"], name: "index_mailboxer_conversation_opt_outs_on_conversation_id"
  add_index "mailboxer_conversation_opt_outs", ["unsubscriber_id", "unsubscriber_type"], name: "index_mailboxer_conversation_opt_outs_on_unsubscriber_id_type"

  create_table "mailboxer_conversations", force: :cascade do |t|
    t.string   "subject",    default: ""
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  create_table "mailboxer_notifications", force: :cascade do |t|
    t.string   "type"
    t.text     "body"
    t.string   "subject",              default: ""
    t.integer  "sender_id"
    t.string   "sender_type"
    t.integer  "conversation_id"
    t.boolean  "draft",                default: false
    t.string   "notification_code"
    t.integer  "notified_object_id"
    t.string   "notified_object_type"
    t.string   "attachment"
    t.datetime "updated_at",                           null: false
    t.datetime "created_at",                           null: false
    t.boolean  "global",               default: false
    t.datetime "expires"
  end

  add_index "mailboxer_notifications", ["conversation_id"], name: "index_mailboxer_notifications_on_conversation_id"
  add_index "mailboxer_notifications", ["notified_object_id", "notified_object_type"], name: "index_mailboxer_notifications_on_notified_object_id_and_type"
  add_index "mailboxer_notifications", ["sender_id", "sender_type"], name: "index_mailboxer_notifications_on_sender_id_and_sender_type"
  add_index "mailboxer_notifications", ["type"], name: "index_mailboxer_notifications_on_type"

  create_table "mailboxer_receipts", force: :cascade do |t|
    t.integer  "receiver_id"
    t.string   "receiver_type"
    t.integer  "notification_id",                            null: false
    t.boolean  "is_read",                    default: false
    t.boolean  "trashed",                    default: false
    t.boolean  "deleted",                    default: false
    t.string   "mailbox_type",    limit: 25
    t.datetime "created_at",                                 null: false
    t.datetime "updated_at",                                 null: false
  end

  add_index "mailboxer_receipts", ["notification_id"], name: "index_mailboxer_receipts_on_notification_id"
  add_index "mailboxer_receipts", ["receiver_id", "receiver_type"], name: "index_mailboxer_receipts_on_receiver_id_and_receiver_type"

  create_table "mentions", force: :cascade do |t|
    t.integer  "user_id",    null: false
    t.integer  "opinion_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "mentions", ["opinion_id"], name: "index_mentions_on_opinion_id"
  add_index "mentions", ["user_id"], name: "index_mentions_on_user_id"

  create_table "opinions", force: :cascade do |t|
    t.text     "body"
    t.integer  "discussion_id", null: false
    t.integer  "user_id",       null: false
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "opinions", ["discussion_id"], name: "index_opinions_on_discussion_id"
  add_index "opinions", ["user_id"], name: "index_opinions_on_user_id"

  create_table "parti_sso_client_api_keys", force: :cascade do |t|
    t.integer  "user_id",                           null: false
    t.string   "digest",                            null: false
    t.string   "client",                            null: false
    t.integer  "authentication_id",                 null: false
    t.datetime "expires_at",                        null: false
    t.datetime "last_access_at",                    null: false
    t.boolean  "is_locked",         default: false, null: false
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
  end

  add_index "parti_sso_client_api_keys", ["client"], name: "index_parti_sso_client_api_keys_on_client"
  add_index "parti_sso_client_api_keys", ["user_id", "client"], name: "index_parti_sso_client_api_keys_on_user_id_and_client", unique: true

  create_table "proposals", force: :cascade do |t|
    t.text     "body"
    t.integer  "discussion_id",                    null: false
    t.integer  "user_id",                          null: false
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.integer  "sequential_id",                    null: false
    t.integer  "in_favor_votes_count", default: 0, null: false
    t.integer  "opposed_votes_count",  default: 0, null: false
  end

  add_index "proposals", ["discussion_id"], name: "index_proposals_on_discussion_id"
  add_index "proposals", ["sequential_id", "discussion_id"], name: "index_proposals_on_sequential_id_and_discussion_id", unique: true
  add_index "proposals", ["user_id"], name: "index_proposals_on_user_id"

  create_table "reactions", force: :cascade do |t|
    t.integer "user_id",    null: false
    t.integer "opinion_id", null: false
    t.string  "token",      null: false
  end

  add_index "reactions", ["opinion_id", "token", "user_id"], name: "index_reactions_on_opinion_id_and_token_and_user_id", unique: true
  add_index "reactions", ["opinion_id"], name: "index_reactions_on_opinion_id"
  add_index "reactions", ["user_id"], name: "index_reactions_on_user_id"

  create_table "read_marks", force: :cascade do |t|
    t.integer  "readable_id"
    t.string   "readable_type", null: false
    t.integer  "reader_id"
    t.string   "reader_type",   null: false
    t.datetime "timestamp"
  end

  add_index "read_marks", ["reader_id", "reader_type", "readable_type", "readable_id"], name: "read_marks_reader_readable_index"

  create_table "request_to_joins", force: :cascade do |t|
    t.integer  "user_id",    null: false
    t.integer  "canoe_id",   null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "request_to_joins", ["canoe_id"], name: "index_request_to_joins_on_canoe_id"
  add_index "request_to_joins", ["user_id", "canoe_id"], name: "index_request_to_joins_on_user_id_and_canoe_id", unique: true

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
    t.string   "choice",      null: false
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "votes", ["proposal_id"], name: "index_votes_on_proposal_id"
  add_index "votes", ["user_id"], name: "index_votes_on_user_id"

end
