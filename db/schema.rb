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

ActiveRecord::Schema.define(version: 20161122065637) do

  create_table "contests", force: :cascade do |t|
    t.datetime "start_date"
    t.datetime "end_date"
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "teacher_id"
    t.index ["teacher_id"], name: "index_contests_on_teacher_id"
  end

  create_table "create_problem_contest_relationships", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "group_and_contests", force: :cascade do |t|
    t.integer  "group_id"
    t.integer  "contest_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "groups", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "teacher_id"
    t.index ["teacher_id"], name: "index_groups_on_teacher_id"
  end

  create_table "has_groups", force: :cascade do |t|
    t.integer "student_id"
    t.integer "group_id"
    t.index ["group_id"], name: "index_has_groups_on_group_id"
    t.index ["student_id"], name: "index_has_groups_on_student_id"
  end

  create_table "problem_contest_relationships", force: :cascade do |t|
    t.integer "problem_id"
    t.integer "contest_id"
    t.integer "score"
    t.index ["contest_id"], name: "index_problem_contest_relationships_on_contest_id"
    t.index ["problem_id"], name: "index_problem_contest_relationships_on_problem_id"
  end

  create_table "problems", force: :cascade do |t|
    t.string   "name"
    t.string   "url_statement"
    t.float    "time_limit"
    t.integer  "languages"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  create_table "students", force: :cascade do |t|
    t.string   "username",   null: false
    t.integer  "cod"
    t.integer  "semester"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "submissions", force: :cascade do |t|
    t.string   "verdict"
    t.string   "language"
    t.float    "execution_time"
    t.text     "url_code"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.integer  "problem_id"
    t.integer  "user_id"
    t.string   "api_ids"
    t.boolean  "in_queue"
    t.string   "final_verdict"
    t.index ["problem_id"], name: "index_submissions_on_problem_id"
    t.index ["user_id"], name: "index_submissions_on_user_id"
  end

  create_table "teachers", force: :cascade do |t|
    t.string   "username",   null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "test_cases", force: :cascade do |t|
    t.string   "url_input"
    t.string   "url_output"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "problem_id"
    t.index ["problem_id"], name: "index_test_cases_on_problem_id"
  end

  create_table "user_contest_relationships", force: :cascade do |t|
    t.integer "user_id"
    t.integer "contest_id"
    t.index ["contest_id"], name: "index_user_contest_relationships_on_contest_id"
    t.index ["user_id"], name: "index_user_contest_relationships_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "full_name"
    t.string   "username",               default: "", null: false
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["username"], name: "index_users_on_username", unique: true
  end

end
