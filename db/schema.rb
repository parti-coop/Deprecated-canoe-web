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

ActiveRecord::Schema.define(version: 20160506080612) do

  create_table "activities", force: :cascade do |t|
    t.integer  "trackable_id"
    t.string   "trackable_type"
    t.integer  "owner_id"
    t.string   "owner_type"
    t.string   "key"
    t.text     "parameters"
    t.integer  "recipient_id"
    t.string   "recipient_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "subject_id",     null: false
    t.string   "subject_type",   null: false
    t.integer  "measure_id"
    t.string   "measure_type"
    t.string   "task"
  end

  add_index "activities", ["measure_type", "measure_id"], name: "index_activities_on_measure_type_and_measure_id"
  add_index "activities", ["owner_id", "owner_type"], name: "index_activities_on_owner_id_and_owner_type"
  add_index "activities", ["recipient_id", "recipient_type"], name: "index_activities_on_recipient_id_and_recipient_type"
  add_index "activities", ["subject_type", "subject_id"], name: "index_activities_on_subject_type_and_subject_id"
  add_index "activities", ["trackable_id", "trackable_type"], name: "index_activities_on_trackable_id_and_trackable_type"

# Could not dump table "activities_backup" because of following NoMethodError
#   undefined method `[]' for nil:NilClass

  create_table "attachments", force: :cascade do |t|
    t.string   "source",            null: false
    t.string   "content_type"
    t.string   "original_filename", null: false
    t.integer  "user_id",           null: false
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.integer  "attachable_id",     null: false
    t.string   "attachable_type",   null: false
    t.datetime "deleted_at"
  end

  add_index "attachments", ["attachable_type", "attachable_id"], name: "index_attachments_on_attachable_type_and_attachable_id"
  add_index "attachments", ["deleted_at"], name: "index_attachments_on_deleted_at"

  create_table "canoes", force: :cascade do |t|
    t.string   "title",                                     null: false
    t.integer  "user_id",                                   null: false
    t.datetime "created_at",                                null: false
    t.datetime "updated_at",                                null: false
    t.text     "theme"
    t.string   "slug",                                      null: false
    t.string   "logo"
    t.string   "cover"
    t.string   "slack_webhook_url"
    t.datetime "deleted_at"
    t.boolean  "is_able_to_request_to_join", default: true
    t.datetime "sailed_at",                                 null: false
    t.integer  "crews_count",                default: 0
    t.integer  "discussions_count",          default: 0
    t.integer  "opinions_count",             default: 0
  end

  add_index "canoes", ["deleted_at"], name: "index_canoes_on_deleted_at"
  add_index "canoes", ["slug"], name: "index_canoes_on_slug", unique: true
  add_index "canoes", ["user_id"], name: "index_canoes_on_user_id"

  create_table "crews", force: :cascade do |t|
    t.integer  "user_id",    null: false
    t.integer  "host_id",    null: false
    t.integer  "canoe_id",   null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "crews", ["canoe_id"], name: "index_crews_on_canoe_id"
  add_index "crews", ["host_id"], name: "index_crews_on_host_id"
  add_index "crews", ["user_id", "canoe_id"], name: "index_crews_on_user_id_and_canoe_id", unique: true

  create_table "devices", force: :cascade do |t|
    t.integer "user_id",         null: false
    t.string  "device_id"
    t.string  "device_platform"
  end

  add_index "devices", ["user_id", "device_id", "device_platform"], name: "index_devices_on_user_id_and_device_id_and_device_platform", unique: true
  add_index "devices", ["user_id"], name: "index_devices_on_user_id"

  create_table "discussions", force: :cascade do |t|
    t.string   "subject",                     null: false
    t.integer  "user_id",                     null: false
    t.integer  "canoe_id",                    null: false
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.text     "decision"
    t.datetime "discussed_at",                null: false
    t.datetime "deleted_at"
    t.integer  "sequential_id",               null: false
    t.integer  "proposals_count", default: 0
    t.integer  "opinions_count",  default: 0
  end

  add_index "discussions", ["canoe_id"], name: "index_discussions_on_canoe_id"
  add_index "discussions", ["deleted_at"], name: "index_discussions_on_deleted_at"
  add_index "discussions", ["sequential_id", "canoe_id"], name: "index_discussions_on_sequential_id_and_canoe_id", unique: true
  add_index "discussions", ["user_id"], name: "index_discussions_on_user_id"

  create_table "invitations", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "email",      null: false
    t.integer  "host_id",    null: false
    t.integer  "canoe_id",   null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "invitations", ["canoe_id"], name: "index_invitations_on_canoe_id"
  add_index "invitations", ["email", "canoe_id"], name: "index_invitations_on_email_and_canoe_id", unique: true
  add_index "invitations", ["user_id", "canoe_id"], name: "index_invitations_on_user_id_and_canoe_id", unique: true

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

  create_table "old_users", force: :cascade do |t|
    t.string   "email",           null: false
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.string   "nickname",        null: false
    t.datetime "home_visited_at", null: false
  end

  add_index "old_users", ["email"], name: "index_old_users_on_email", unique: true
  add_index "old_users", ["nickname"], name: "index_old_users_on_nickname", unique: true

  create_table "opinions", force: :cascade do |t|
    t.text     "body"
    t.integer  "discussion_id", null: false
    t.integer  "user_id",       null: false
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.datetime "deleted_at"
  end

  add_index "opinions", ["deleted_at"], name: "index_opinions_on_deleted_at"
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
    t.datetime "deleted_at"
  end

  add_index "proposals", ["deleted_at"], name: "index_proposals_on_deleted_at"
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
    t.text     "reason"
  end

  add_index "request_to_joins", ["canoe_id"], name: "index_request_to_joins_on_canoe_id"
  add_index "request_to_joins", ["user_id", "canoe_id"], name: "index_request_to_joins_on_user_id_and_canoe_id", unique: true

  create_table "users", force: :cascade do |t|
    t.string   "email",                             default: "",      null: false
    t.string   "encrypted_password",                default: "",      null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                     default: 0,       null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.string   "provider",                          default: "email", null: false
    t.string   "uid",                                                 null: false
    t.string   "nickname",                                            null: false
    t.string   "image"
    t.datetime "home_visited_at"
    t.datetime "created_at",                                          null: false
    t.datetime "updated_at",                                          null: false
    t.datetime "deleted_at"
    t.string   "encrypted_authentication_token"
    t.string   "encrypted_authentication_token_iv"
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
  add_index "users", ["deleted_at"], name: "index_users_on_deleted_at"
  add_index "users", ["nickname"], name: "index_users_on_nickname", unique: true
  add_index "users", ["provider", "uid"], name: "index_users_on_provider_and_uid", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

  create_table "versions", force: :cascade do |t|
    t.string   "item_type",                         null: false
    t.integer  "item_id",                           null: false
    t.string   "event",                             null: false
    t.string   "whodunnit"
    t.text     "object",         limit: 1073741823
    t.datetime "created_at"
    t.text     "object_changes", limit: 1073741823
  end

  add_index "versions", ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id"

  create_table "votes", force: :cascade do |t|
    t.integer  "proposal_id", null: false
    t.integer  "user_id",     null: false
    t.string   "choice",      null: false
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.datetime "deleted_at"
  end

  add_index "votes", ["deleted_at"], name: "index_votes_on_deleted_at"
  add_index "votes", ["proposal_id"], name: "index_votes_on_proposal_id"
  add_index "votes", ["user_id", "proposal_id", "deleted_at"], name: "index_votes_on_user_id_and_proposal_id_and_deleted_at", unique: true
  add_index "votes", ["user_id"], name: "index_votes_on_user_id"

end
