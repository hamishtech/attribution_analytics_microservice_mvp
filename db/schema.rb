# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2023_02_12_103607) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "events", force: :cascade do |t|
    t.string "name", null: false
    t.string "fingerprint", null: false
    t.string "user_id", null: false
    t.datetime "created_at", null: false
    t.index ["user_id", "name"], name: "index_events_on_user_id_and_name", unique: true
  end

  create_table "pageviews", force: :cascade do |t|
    t.string "fingerprint", null: false
    t.string "user_id"
    t.string "url", null: false
    t.string "referrer_url"
    t.string "referrer_source"
    t.string "utm_source"
    t.string "utm_campaign"
    t.string "utm_medium"
    t.string "utm_content"
    t.datetime "created_at", null: false
    t.index ["fingerprint", "created_at"], name: "index_pageviews_on_fingerprint_and_created_at", unique: true
  end

end
