# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of ActiveRecord to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 1) do

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
