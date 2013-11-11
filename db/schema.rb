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

ActiveRecord::Schema.define(:version => 20131101200301) do

  create_table "comments", :force => true do |t|
    t.integer  "commentable_id",    :default => 0
    t.string   "commentable_type",  :default => ""
    t.string   "title",             :default => ""
    t.text     "body"
    t.string   "subject",           :default => ""
    t.integer  "user_id",           :default => 0,     :null => false
    t.integer  "parent_id"
    t.integer  "lft"
    t.integer  "rgt"
    t.datetime "created_at",                           :null => false
    t.datetime "updated_at",                           :null => false
    t.boolean  "notification_sent", :default => false
  end

  add_index "comments", ["commentable_id"], :name => "index_comments_on_commentable_id"
  add_index "comments", ["notification_sent"], :name => "index_comments_on_notification_sent"
  add_index "comments", ["user_id"], :name => "index_comments_on_user_id"

  create_table "communities", :force => true do |t|
    t.string   "name"
    t.string   "subdomain"
    t.integer  "max_users",  :default => 20
    t.datetime "created_at",                 :null => false
    t.datetime "updated_at",                 :null => false
    t.integer  "creator_id"
  end

  create_table "community_users", :force => true do |t|
    t.integer  "community_id"
    t.integer  "user_id"
    t.string   "role",         :default => "normal"
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
  end

  create_table "event_occurrences", :force => true do |t|
    t.datetime "starts_at"
    t.datetime "register_deadline"
    t.integer  "event_id"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
  end

  create_table "event_roles", :force => true do |t|
    t.string   "name"
    t.time     "time"
    t.boolean  "has_task_occurrence"
    t.integer  "max_users"
    t.integer  "event_id"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
  end

  create_table "events", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "community_user_id"
    t.string   "type"
    t.boolean  "deleted",           :default => false
    t.boolean  "active",            :default => true
    t.boolean  "has_roles",         :default => false
    t.datetime "created_at",                           :null => false
    t.datetime "updated_at",                           :null => false
  end

  create_table "invitations", :force => true do |t|
    t.integer  "invitor_id"
    t.integer  "invitee_id"
    t.integer  "community_id"
    t.string   "invitee_email"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.string   "token"
    t.string   "status"
  end

  add_index "invitations", ["token"], :name => "index_invitations_on_token"

  create_table "payments", :force => true do |t|
    t.string   "title"
    t.integer  "community_user_id"
    t.date     "date"
    t.text     "description"
    t.text     "dynamic_attributes"
    t.string   "type"
    t.decimal  "price",              :precision => 8, :scale => 2
    t.datetime "created_at",                                       :null => false
    t.datetime "updated_at",                                       :null => false
    t.integer  "payment_id"
  end

  create_table "repeatable_items", :force => true do |t|
    t.string   "repeat_every_unit"
    t.integer  "repeat_number",       :default => 0
    t.boolean  "repeat_infinite",     :default => true
    t.datetime "next_occurrence"
    t.string   "only_on_week_days"
    t.integer  "repeat_every_number", :default => 0
    t.integer  "repeatable_id"
    t.string   "repeatable_type"
    t.string   "deadline_unit"
    t.integer  "deadline_number",     :default => 0
    t.boolean  "has_deadline",        :default => true
    t.boolean  "enabled",             :default => true
    t.datetime "created_at",                            :null => false
    t.datetime "updated_at",                            :null => false
  end

  create_table "start_saldo_distributions", :force => true do |t|
    t.integer  "community_id"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "taggings", :force => true do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.integer  "tagger_id"
    t.string   "tagger_type"
    t.string   "context",       :limit => 128
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id"], :name => "index_taggings_on_tag_id"
  add_index "taggings", ["taggable_id", "taggable_type", "context"], :name => "index_taggings_on_taggable_id_and_taggable_type_and_context"

  create_table "tags", :force => true do |t|
    t.string "name"
  end

  create_table "task_occurrences", :force => true do |t|
    t.integer  "task_id"
    t.boolean  "checked",                 :default => false
    t.date     "deadline"
    t.text     "remarks"
    t.integer  "user_id"
    t.datetime "completed_at"
    t.integer  "time_in_minutes",         :default => 0
    t.datetime "created_at",                                 :null => false
    t.datetime "updated_at",                                 :null => false
    t.string   "task_name"
    t.boolean  "should_be_checked",       :default => true
    t.boolean  "should_send_assign_mail", :default => false
    t.boolean  "reminder_mail_sent",      :default => false
    t.integer  "community_id"
    t.text     "task_description"
  end

  create_table "tasks", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.time     "time"
    t.integer  "deadline"
    t.string   "deadline_unit"
    t.boolean  "should_be_checked"
    t.integer  "interval"
    t.string   "interval_unit"
    t.integer  "user_id"
    t.integer  "community_id"
    t.integer  "repeat"
    t.date     "next_occurrence"
    t.string   "allocation_mode"
    t.integer  "allocated_user_id"
    t.boolean  "instantiate_automatically"
    t.boolean  "repeat_infinite"
    t.string   "ordered_user_ids"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
    t.string   "ignored_user_ids"
  end

  create_table "user_saldo_modifications", :force => true do |t|
    t.decimal  "price",             :precision => 8, :scale => 2
    t.integer  "chargeable_id"
    t.integer  "community_user_id"
    t.decimal  "percentage",        :precision => 8, :scale => 2
    t.boolean  "checked"
    t.datetime "created_at",                                      :null => false
    t.datetime "updated_at",                                      :null => false
    t.string   "chargeable_type"
  end

  create_table "users", :force => true do |t|
    t.string   "email",                  :default => "",       :null => false
    t.string   "encrypted_password",     :default => "",       :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.string   "locale",                 :default => "en"
    t.string   "global_role",            :default => "normal"
    t.string   "name"
    t.datetime "created_at",                                   :null => false
    t.datetime "updated_at",                                   :null => false
    t.boolean  "receive_assign_mail",    :default => true
    t.boolean  "receive_reminder_mail",  :default => true
    t.boolean  "receive_comment_mail",   :default => true
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
  end

  add_index "users", ["confirmation_token"], :name => "index_users_on_confirmation_token", :unique => true
  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
