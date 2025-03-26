# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# Disable foreign key constraints temporarily
ActiveRecord::Base.connection.execute('PRAGMA foreign_keys = OFF;')

# Clear existing data
Grade.delete_all
Course.delete_all
Student.delete_all
Classroom.delete_all
Teacher.delete_all
Theme.delete_all
Quarter.delete_all
ClassType.delete_all
Room.delete_all
User.delete_all
Role.delete_all

# Re-enable foreign key constraints
ActiveRecord::Base.connection.execute('PRAGMA foreign_keys = ON;')

# Create roles
roles = %w[student teacher dean]
roles.each { |role| Role.create(name: role) }

# Create a dean user
dean = User.create!(
  email: "dean@example.com",
  password: "password",
  password_confirmation: "password",
  first_name: "John",
  last_name: "Dean"
)
dean.add_role(:dean)

# Create teachers
teachers = []
3.times do |i|
  user = User.create!(
    email: "teacher#{i+1}@example.com",
    password: "password",
    password_confirmation: "password",
    first_name: "Teacher",
    last_name: "#{i+1}"
  )
  user.add_role(:teacher)
  teachers << Teacher.create!(
    user: user,
    IBAN: "CH#{rand(1000..9999)} #{rand(1000..9999)} #{rand(1000..9999)} #{rand(1000..9999)}",
    state: :active,
    is_archived: false
  )
end

# Create students
students = []
5.times do |i|
  user = User.create!(
    email: "student#{i+1}@example.com",
    password: "password",
    password_confirmation: "password",
    first_name: "Student",
    last_name: "#{i+1}"
  )
  user.add_role(:student)
  students << user
end

# Create a quarter
quarter = Quarter.create!(
  name: "Spring 2024",
  start_date: Date.new(2024, 1, 1),
  end_date: Date.new(2024, 3, 31),
  is_archived: false
)

# Create a room
room = Room.create!(
  name: "Room 101",
  capacity: 30,
  is_archived: false
)

# Create a class type
class_type = ClassType.create!(
  name: "Regular Class",
  description: "Standard classroom setting",
  is_archived: false
)

# Create a classroom
classroom = Classroom.create!(
  name: "Class 1A",
  teacher: teachers.first,
  class_type: class_type,
  room: room,
  quarter: quarter,
  is_archived: false
)

# Create students in the classroom
students.each do |student|
  Student.create!(
    user: student,
    classroom: classroom,
    state: :active,
    is_archived: false
  )
end

# Create themes (subjects)
themes = [
  Theme.create!(module_name: "Mathematics", module_description: "Advanced Mathematics", is_archived: false),
  Theme.create!(module_name: "Physics", module_description: "General Physics", is_archived: false),
  Theme.create!(module_name: "Chemistry", module_description: "Organic Chemistry", is_archived: false),
  Theme.create!(module_name: "Biology", module_description: "Cell Biology", is_archived: false),
  Theme.create!(module_name: "Literature", module_description: "World Literature", is_archived: false)
]

# Create a weekly schedule
schedule = [
  # Monday
  { weekday: :monday, start_time: "08:00", end_time: "09:30", theme: themes[0], teacher: teachers[0] }, # Math
  { weekday: :monday, start_time: "10:00", end_time: "11:30", theme: themes[1], teacher: teachers[1] }, # Physics

  # Tuesday
  { weekday: :tuesday, start_time: "09:00", end_time: "10:30", theme: themes[2], teacher: teachers[2] }, # Chemistry
  { weekday: :tuesday, start_time: "13:00", end_time: "14:30", theme: themes[0], teacher: teachers[0] }, # Math

  # Wednesday
  { weekday: :wednesday, start_time: "08:00", end_time: "09:30", theme: themes[3], teacher: teachers[1] }, # Biology
  { weekday: :wednesday, start_time: "10:00", end_time: "11:30", theme: themes[4], teacher: teachers[2] }, # Literature

  # Thursday
  { weekday: :thursday, start_time: "09:00", end_time: "10:30", theme: themes[1], teacher: teachers[1] }, # Physics
  { weekday: :thursday, start_time: "13:00", end_time: "14:30", theme: themes[2], teacher: teachers[2] }, # Chemistry

  # Friday
  { weekday: :friday, start_time: "08:00", end_time: "09:30", theme: themes[0], teacher: teachers[0] }, # Math
  { weekday: :friday, start_time: "10:00", end_time: "11:30", theme: themes[3], teacher: teachers[1] }  # Biology
]

# Create courses
schedule.each do |course_data|
  Course.create!(
    start_time: Time.parse(course_data[:start_time]),
    end_time: Time.parse(course_data[:end_time]),
    weekday: course_data[:weekday],
    quarter: quarter,
    theme: course_data[:theme],
    classroom: classroom,
    teacher: course_data[:teacher],
    is_archived: false
  )
end

# Create grades for each student in each course
puts "\nCreating grades..."
Course.all.each do |course|
  course.classroom.students.each do |student|
    # Create 2-3 grades per course for each student
    rand(2..3).times do
      Grade.create!(
        student: student,
        teacher: course.teacher,
        course: course,
        grade: rand(4.0..6.0).round(1),  # Grades between 4.0 and 6.0
        grading_date: rand(course.quarter.start_date..course.quarter.end_date),
        is_archived: false
      )
    end
  end
end

puts "Created #{Grade.count} grades"

puts "Seeding completed!"
