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

ActiveRecord::Schema[8.1].define(version: 2026_02_12_130008) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"
  enable_extension "pgcrypto"

  create_table "clients", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "deleted_at"
    t.string "email", limit: 100
    t.string "name", limit: 100
    t.datetime "updated_at", null: false
    t.uuid "uuid", default: -> { "gen_random_uuid()" }, null: false
    t.index ["deleted_at"], name: "index_clients_on_deleted_at"
    t.index ["email"], name: "index_clients_on_email"
    t.index ["uuid"], name: "index_clients_on_uuid"
  end

  create_table "departaments", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "deleted_at"
    t.string "name", limit: 100
    t.datetime "updated_at", null: false
    t.uuid "uuid", default: -> { "gen_random_uuid()" }, null: false
    t.index ["deleted_at"], name: "index_departaments_on_deleted_at"
    t.index ["uuid"], name: "index_departaments_on_uuid"
  end

  create_table "employees", force: :cascade do |t|
    t.string "city", limit: 100
    t.bigint "client_id"
    t.string "corporation_email", limit: 100
    t.datetime "created_at", null: false
    t.datetime "deleted_at"
    t.bigint "departament_id"
    t.string "gender", limit: 10
    t.bigint "job_title_id"
    t.string "name", limit: 100
    t.string "personal_email", limit: 100
    t.bigint "role_id"
    t.string "tenure", limit: 50
    t.string "uf", limit: 2
    t.datetime "updated_at", null: false
    t.uuid "uuid", default: -> { "gen_random_uuid()" }, null: false
    t.index ["client_id"], name: "index_employees_on_client_id"
    t.index ["corporation_email"], name: "index_employees_on_corporation_email"
    t.index ["deleted_at"], name: "index_employees_on_deleted_at"
    t.index ["departament_id"], name: "index_employees_on_departament_id"
    t.index ["job_title_id"], name: "index_employees_on_job_title_id"
    t.index ["role_id"], name: "index_employees_on_role_id"
    t.index ["uuid"], name: "index_employees_on_uuid"
  end

  create_table "job_titles", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "deleted_at"
    t.string "name", limit: 100
    t.datetime "updated_at", null: false
    t.uuid "uuid", default: -> { "gen_random_uuid()" }, null: false
    t.index ["deleted_at"], name: "index_job_titles_on_deleted_at"
    t.index ["uuid"], name: "index_job_titles_on_uuid"
  end

  create_table "roles", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "deleted_at"
    t.string "name", limit: 100
    t.datetime "updated_at", null: false
    t.uuid "uuid", default: -> { "gen_random_uuid()" }, null: false
    t.index ["deleted_at"], name: "index_roles_on_deleted_at"
    t.index ["uuid"], name: "index_roles_on_uuid"
  end

  create_table "survey_question_responses", force: :cascade do |t|
    t.text "comment"
    t.datetime "created_at", null: false
    t.datetime "deleted_at"
    t.bigint "employee_id", null: false
    t.bigint "survey_question_id", null: false
    t.datetime "updated_at", null: false
    t.uuid "uuid", default: -> { "gen_random_uuid()" }, null: false
    t.integer "value"
    t.index ["deleted_at"], name: "index_survey_question_responses_on_deleted_at"
    t.index ["employee_id"], name: "index_survey_question_responses_on_employee_id"
    t.index ["survey_question_id", "employee_id"], name: "index_survey_question_responses_on_question_and_employee"
    t.index ["survey_question_id"], name: "index_survey_question_responses_on_survey_question_id"
    t.index ["uuid"], name: "index_survey_question_responses_on_uuid"
  end

  create_table "survey_questions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "deleted_at"
    t.text "question"
    t.bigint "survey_id", null: false
    t.datetime "updated_at", null: false
    t.uuid "uuid", default: -> { "gen_random_uuid()" }, null: false
    t.index ["deleted_at"], name: "index_survey_questions_on_deleted_at"
    t.index ["survey_id"], name: "index_survey_questions_on_survey_id"
    t.index ["uuid"], name: "index_survey_questions_on_uuid"
  end

  create_table "surveys", force: :cascade do |t|
    t.bigint "client_id"
    t.datetime "created_at", null: false
    t.datetime "deleted_at"
    t.text "description"
    t.string "name", limit: 100
    t.datetime "updated_at", null: false
    t.uuid "uuid", default: -> { "gen_random_uuid()" }, null: false
    t.index ["client_id"], name: "index_surveys_on_client_id"
    t.index ["deleted_at"], name: "index_surveys_on_deleted_at"
    t.index ["uuid"], name: "index_surveys_on_uuid"
  end

  add_foreign_key "employees", "clients"
  add_foreign_key "employees", "departaments"
  add_foreign_key "employees", "job_titles"
  add_foreign_key "employees", "roles"
  add_foreign_key "survey_question_responses", "employees"
  add_foreign_key "survey_question_responses", "survey_questions"
  add_foreign_key "survey_questions", "surveys"
  add_foreign_key "surveys", "clients"
end
