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

# Create users
users = []
10.times do |i|
  users << User.create!(email: "user#{i}@example.com", password: "password", password_confirmation: "password")
end

# Assign roles to users
users[0..2].each { |user| user.add_role(:student) }
users[3..5].each { |user| user.add_role(:teacher) }
users[6..7].each { |user| user.add_role(:dean) }

# Create teachers
teachers = []
users[3..5].each do |user|
  teachers << Teacher.create!(user: user, IBAN: "DE89370400440532013000", state: :active, is_dean: false, is_archived: false)
end

# Create quarters
quarters = []
4.times do |i|
  quarters << Quarter.create!(name: "Quarter #{i + 1}", start_date: Date.today + i.months, end_date: Date.today + (i + 1).months, is_archived: false)
end

# Create class types
class_types = []
3.times do |i|
  class_types << ClassType.create!(name: "Class Type #{i + 1}", description: "Description for class type #{i + 1}", is_archived: false)
end

# Create rooms
rooms = []
3.times do |i|
  rooms << Room.create!(name: "Room #{i + 1}", building: "Building #{i + 1}", floor: i + 1, capacity: (i + 1) * 10, is_archived: false)
end

# Create classrooms
classrooms = []
3.times do |i|
  classrooms << Classroom.create!(name: "Classroom #{i + 1}", class_type: class_types[i], room: rooms[i], teacher: teachers[i], quarter: quarters[i], is_archived: false)
end

# Create students
students = []
users[0..2].each_with_index do |user, index|
  students << Student.create!(user: user, classroom: classrooms[index % classrooms.size], state: :active, is_archived: false)
end

# Create themes
themes = []
3.times do |i|
  themes << Theme.create!(module_name: "Theme #{i + 1}", module_description: "Description for theme #{i + 1}", is_archived: false)
end

# Create courses
courses = []
3.times do |i|
  courses << Course.create!(start_time: Time.now, end_time: Time.now + 1.hour, weekday: :monday, quarter: quarters[i], theme: themes[i], classroom: classrooms[i], teacher: teachers[i], is_archived: false)
end

# Create grades
students.each do |student|
  courses.each do |course|
    Grade.create!(student: student, teacher: course.teacher, course: course, grade: rand(60..100) / 10.0, grading_date: Date.today, is_archived: false)
  end
end
