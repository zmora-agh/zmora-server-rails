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

ActiveRecord::Schema.define(version: 20170516091804) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "answers", force: :cascade do |t|
    t.bigint "question_id"
    t.bigint "author_id"
    t.text "answer"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["author_id"], name: "index_answers_on_author_id"
    t.index ["question_id"], name: "index_answers_on_question_id"
  end

  create_table "contest_ownerships", force: :cascade do |t|
    t.bigint "contest_id"
    t.bigint "owner_id"
    t.string "join_password"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["contest_id"], name: "index_contest_ownerships_on_contest_id"
    t.index ["owner_id"], name: "index_contest_ownerships_on_owner_id"
  end

  create_table "contest_problems", force: :cascade do |t|
    t.bigint "contest_id"
    t.bigint "problem_id"
    t.string "shortcode"
    t.string "category"
    t.integer "base_points"
    t.datetime "soft_deadline"
    t.datetime "hard_deadline"
    t.boolean "required"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["contest_id"], name: "index_contest_problems_on_contest_id"
    t.index ["problem_id"], name: "index_contest_problems_on_problem_id"
  end

  create_table "contests", force: :cascade do |t|
    t.string "shortcode"
    t.string "name"
    t.datetime "start"
    t.integer "signup_duration"
    t.integer "duration"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "problem_examples", force: :cascade do |t|
    t.bigint "problem_id"
    t.integer "number"
    t.text "input"
    t.text "result"
    t.text "explanation"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["problem_id"], name: "index_problem_examples_on_problem_id"
  end

  create_table "problems", force: :cascade do |t|
    t.bigint "author_id"
    t.string "name"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["author_id"], name: "index_problems_on_author_id"
  end

  create_table "questions", force: :cascade do |t|
    t.bigint "author_id"
    t.text "question"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["author_id"], name: "index_questions_on_author_id"
  end

  create_table "submits", force: :cascade do |t|
    t.bigint "contest_problem_id"
    t.bigint "author_id"
    t.integer "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["author_id"], name: "index_submits_on_author_id"
    t.index ["contest_problem_id"], name: "index_submits_on_contest_problem_id"
  end

  create_table "test_results", force: :cascade do |t|
    t.bigint "submit_id"
    t.integer "status"
    t.integer "execution_time"
    t.integer "ram_usage"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["submit_id"], name: "index_test_results_on_submit_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "nick"
    t.string "password_digest"
    t.string "email"
    t.string "name"
    t.text "about"
    t.string "avatar_file_name"
    t.string "avatar_content_type"
    t.integer "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.boolean "is_admin", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "answers", "questions"
  add_foreign_key "answers", "users", column: "author_id"
  add_foreign_key "contest_ownerships", "contests"
  add_foreign_key "contest_ownerships", "users", column: "owner_id"
  add_foreign_key "contest_problems", "contests"
  add_foreign_key "contest_problems", "problems"
  add_foreign_key "problem_examples", "problems"
  add_foreign_key "problems", "users", column: "author_id"
  add_foreign_key "questions", "users", column: "author_id"
  add_foreign_key "submits", "contest_problems"
  add_foreign_key "submits", "users", column: "author_id"
  add_foreign_key "test_results", "submits"
end
