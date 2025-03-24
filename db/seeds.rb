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

# Create test users with recognizable credentials
# Create a dean user
dean = User.create!(
  email: "dean@example.com",
  password: "password",
  password_confirmation: "password"
)
dean.add_role(:dean)

# Create teacher users
teacher1 = User.create!(
  email: "teacher1@example.com",
  password: "password",
  password_confirmation: "password"
)
teacher1.add_role(:teacher)

teacher2 = User.create!(
  email: "teacher2@example.com",
  password: "password",
  password_confirmation: "password"
)
teacher2.add_role(:teacher)

# Create student users
student1 = User.create!(
  email: "student1@example.com",
  password: "password",
  password_confirmation: "password"
)
student1.add_role(:student)

student2 = User.create!(
  email: "student2@example.com",
  password: "password",
  password_confirmation: "password"
)
student2.add_role(:student)

student3 = User.create!(
  email: "student3@example.com",
  password: "password",
  password_confirmation: "password"
)
student3.add_role(:student)

# Create a normal user with no specific role
normal_user = User.create!(
  email: "normal@example.com",
  password: "password",
  password_confirmation: "password"
)

# Store all users in an array for later use
users = [ dean, teacher1, teacher2, student1, student2, student3, normal_user ]

# Create teachers
teachers = []
[ teacher1, teacher2 ].each do |user|
  teachers << Teacher.create!(user: user, IBAN: "DE89370400440532013000", state: :active, is_dean: false, is_archived: false)
end

# Create a dean teacher
dean_teacher = Teacher.create!(user: dean, IBAN: "DE89370400440532013000", state: :active, is_dean: true, is_archived: false)

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
  teacher = i == 0 ? dean_teacher : teachers[i-1]
  classrooms << Classroom.create!(name: "Classroom #{i + 1}", class_type: class_types[i], room: rooms[i], teacher: teacher, quarter: quarters[i], is_archived: false)
end

# Create students
students = []
[ student1, student2, student3 ].each_with_index do |user, index|
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
  teacher = i == 0 ? dean_teacher : teachers[i-1]
  courses << Course.create!(start_time: Time.now, end_time: Time.now + 1.hour, weekday: :monday, quarter: quarters[i], theme: themes[i], classroom: classrooms[i], teacher: teacher, is_archived: false)
end

# Create grades
students.each do |student|
  courses.each do |course|
    Grade.create!(student: student, teacher: course.teacher, course: course, grade: rand(60..100) / 10.0, grading_date: Date.today, is_archived: false)
  end
end
