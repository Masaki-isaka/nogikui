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

ActiveRecord::Schema[7.0].define(version: 2021_11_14_015326) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "judges", force: :cascade do |t|
    t.boolean "is_answer"
    t.bigint "question_sort_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "choice"
    t.index ["question_sort_id"], name: "index_judges_on_question_sort_id"
  end

  create_table "options", force: :cascade do |t|
    t.text "content"
    t.boolean "is_answer"
    t.bigint "question_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["question_id"], name: "index_options_on_question_id"
  end

  create_table "question_sorts", force: :cascade do |t|
    t.bigint "question_id", null: false
    t.integer "sort"
    t.string "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["question_id"], name: "index_question_sorts_on_question_id"
  end

  create_table "questions", force: :cascade do |t|
    t.text "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "judges", "question_sorts"
  add_foreign_key "options", "questions"
  add_foreign_key "question_sorts", "questions"
end
