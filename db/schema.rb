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

ActiveRecord::Schema[8.0].define(version: 2025_03_23_231956) do
  create_table "addresses", force: :cascade do |t|
    t.string "city"
    t.string "npa"
    t.string "street"
    t.string "house"
    t.string "apartment_number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "class_types", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.boolean "is_archived"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "classrooms", force: :cascade do |t|
    t.string "name"
    t.integer "class_type_id"
    t.integer "room_id"
    t.integer "teacher_id"
    t.boolean "is_archived"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "quarter_id"
    t.index ["quarter_id"], name: "index_classrooms_on_quarter_id"
  end

  create_table "course_modules", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.boolean "is_archived"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "courses", force: :cascade do |t|
    t.datetime "start_time"
    t.datetime "end_time"
    t.integer "weekday"
    t.integer "quarter_id", null: false
    t.integer "module_id", null: false
    t.integer "classroom_id", null: false
    t.integer "teacher_id", null: false
    t.boolean "is_archived"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["classroom_id"], name: "index_courses_on_classroom_id"
    t.index ["module_id"], name: "index_courses_on_module_id"
    t.index ["quarter_id"], name: "index_courses_on_quarter_id"
    t.index ["teacher_id"], name: "index_courses_on_teacher_id"
  end

  create_table "grades", force: :cascade do |t|
    t.integer "student_id", null: false
    t.integer "teacher_id", null: false
    t.integer "course_id", null: false
    t.decimal "grade", precision: 4, scale: 1
    t.date "grading_date"
    t.boolean "is_archived"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["course_id"], name: "index_grades_on_course_id"
    t.index ["student_id"], name: "index_grades_on_student_id"
    t.index ["teacher_id"], name: "index_grades_on_teacher_id"
  end

  create_table "quarters", force: :cascade do |t|
    t.string "name"
    t.date "start_date"
    t.date "end_date"
    t.boolean "is_archived"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "roles", force: :cascade do |t|
    t.string "name"
    t.string "resource_type"
    t.integer "resource_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name", "resource_type", "resource_id"], name: "index_roles_on_name_and_resource_type_and_resource_id"
    t.index ["name"], name: "index_roles_on_name"
    t.index ["resource_type", "resource_id"], name: "index_roles_on_resource"
  end

  create_table "rooms", force: :cascade do |t|
    t.string "name"
    t.string "building"
    t.integer "floor"
    t.integer "capacity"
    t.boolean "is_archived"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "students", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "classroom_id", null: false
    t.integer "state"
    t.boolean "is_archived"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["classroom_id"], name: "index_students_on_classroom_id"
    t.index ["is_archived"], name: "index_students_on_is_archived"
    t.index ["user_id"], name: "index_students_on_user_id"
  end

  create_table "teachers", force: :cascade do |t|
    t.string "IBAN"
    t.integer "state"
    t.boolean "is_dean"
    t.boolean "is_archived"
    t.integer "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_teachers_on_user_id"
  end

  create_table "themes", force: :cascade do |t|
    t.string "module_name"
    t.text "module_description"
    t.boolean "is_archived"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "to_grades", force: :cascade do |t|
    t.integer "module_id", null: false
    t.integer "student_id", null: false
    t.integer "teacher_id", null: false
    t.integer "quarter_id", null: false
    t.decimal "grade", precision: 2, scale: 1
    t.date "grading_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["module_id"], name: "index_to_grades_on_module_id"
    t.index ["quarter_id"], name: "index_to_grades_on_quarter_id"
    t.index ["student_id"], name: "index_to_grades_on_student_id"
    t.index ["teacher_id"], name: "index_to_grades_on_teacher_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "address_id"
    t.index ["address_id"], name: "index_users_on_address_id"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "users_roles", id: false, force: :cascade do |t|
    t.integer "user_id"
    t.integer "role_id"
    t.index ["role_id"], name: "index_users_roles_on_role_id"
    t.index ["user_id", "role_id"], name: "index_users_roles_on_user_id_and_role_id"
    t.index ["user_id"], name: "index_users_roles_on_user_id"
  end

  add_foreign_key "classrooms", "quarters"
  add_foreign_key "courses", "classrooms"
  add_foreign_key "courses", "modules"
  add_foreign_key "courses", "quarters"
  add_foreign_key "courses", "teachers"
  add_foreign_key "grades", "courses"
  add_foreign_key "grades", "students"
  add_foreign_key "grades", "teachers"
  add_foreign_key "students", "classrooms"
  add_foreign_key "students", "users"
  add_foreign_key "teachers", "users"
  add_foreign_key "to_grades", "course_modules", column: "module_id"
  add_foreign_key "to_grades", "quarters"
  add_foreign_key "to_grades", "students"
  add_foreign_key "to_grades", "users", column: "teacher_id"
  add_foreign_key "users", "addresses"
end
