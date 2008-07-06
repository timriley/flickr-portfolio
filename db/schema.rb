# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20080706055700) do

  create_table "audits", :force => true do |t|
    t.integer  "auditable_id",   :limit => 11
    t.string   "auditable_type"
    t.integer  "user_id",        :limit => 11
    t.string   "user_type"
    t.string   "username"
    t.string   "action"
    t.text     "changes"
    t.integer  "version",        :limit => 11, :default => 0
    t.datetime "created_at"
  end

  add_index "audits", ["auditable_id", "auditable_type"], :name => "auditable_index"
  add_index "audits", ["user_id", "user_type"], :name => "user_index"
  add_index "audits", ["created_at"], :name => "index_audits_on_created_at"

  create_table "bj_config", :primary_key => "bj_config_id", :force => true do |t|
    t.text "hostname"
    t.text "key"
    t.text "value"
    t.text "cast"
  end

  create_table "bj_job", :primary_key => "bj_job_id", :force => true do |t|
    t.text     "command"
    t.text     "state"
    t.integer  "priority",       :limit => 11
    t.text     "tag"
    t.integer  "is_restartable", :limit => 11
    t.text     "submitter"
    t.text     "runner"
    t.integer  "pid",            :limit => 11
    t.datetime "submitted_at"
    t.datetime "started_at"
    t.datetime "finished_at"
    t.text     "env"
    t.text     "stdin"
    t.text     "stdout"
    t.text     "stderr"
    t.integer  "exit_status",    :limit => 11
  end

  create_table "bj_job_archive", :primary_key => "bj_job_archive_id", :force => true do |t|
    t.text     "command"
    t.text     "state"
    t.integer  "priority",       :limit => 11
    t.text     "tag"
    t.integer  "is_restartable", :limit => 11
    t.text     "submitter"
    t.text     "runner"
    t.integer  "pid",            :limit => 11
    t.datetime "submitted_at"
    t.datetime "started_at"
    t.datetime "finished_at"
    t.datetime "archived_at"
    t.text     "env"
    t.text     "stdin"
    t.text     "stdout"
    t.text     "stderr"
    t.integer  "exit_status",    :limit => 11
  end

  create_table "photos", :force => true do |t|
    t.string   "title"
    t.text     "description"
    t.string   "flickr_id"
    t.string   "thumb_source_url"
    t.string   "medium_source_url"
    t.string   "fullsize_source_url"
    t.boolean  "active",              :default => true
    t.datetime "taken_at"
    t.datetime "flickr_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
