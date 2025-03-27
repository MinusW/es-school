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

# Create dean users
deans = []
2.times do |i|
  user = User.create!(
    email: "dean#{i+1}@example.com",
    password: "password",
    password_confirmation: "password",
    first_name: "Dean",
    last_name: "Admin#{i+1}"
  )
  user.add_role(:dean)
  deans << user
end

# Create teachers
teachers = []
6.times do |i|
  user = User.create!(
    email: "teacher#{i+1}@example.com",
    password: "password",
    password_confirmation: "password",
    first_name: ["James", "Sarah", "Michael", "Emma", "Robert", "Julia"][i],
    last_name: ["Smith", "Johnson", "Williams", "Brown", "Jones", "Davis"][i]
  )
  user.add_role(:teacher)
  teachers << Teacher.create!(
    user: user,
    IBAN: "CH#{rand(1000..9999)} #{rand(1000..9999)} #{rand(1000..9999)} #{rand(1000..9999)}",
    state: :active,
    is_archived: false
  )
end

# Create quarters for past, current, and future periods
past_quarter = Quarter.create!(
  name: "Fall 2023",
  start_date: Date.new(2023, 9, 1),
  end_date: Date.new(2023, 12, 31),
  is_archived: false
)

winter_quarter = Quarter.create!(
  name: "Winter 2023-2024",
  start_date: Date.new(2023, 12, 1),
  end_date: Date.new(2024, 2, 29),
  is_archived: false
)

current_quarter = Quarter.create!(
  name: "Spring 2024",
  start_date: Date.new(2024, 3, 1),
  end_date: Date.new(2024, 5, 31),
  is_archived: false
)

next_quarter = Quarter.create!(
  name: "Summer 2024",
  start_date: Date.new(2024, 6, 1),
  end_date: Date.new(2024, 8, 31),
  is_archived: false
)

future_quarter = Quarter.create!(
  name: "Fall 2024",
  start_date: Date.new(2024, 9, 1),
  end_date: Date.new(2024, 12, 31),
  is_archived: false
)

# Create rooms
rooms = []
10.times do |i|
  rooms << Room.create!(
    name: "Room #{101 + i}",
    building: ["Main Building", "Science Wing", "Arts Center", "Technology Lab"][i % 4],
    floor: (i % 3) + 1,
    capacity: rand(20..35),
    is_archived: i >= 8 # 8 active rooms, 2 archived
  )
end

# Create class types
class_types = [
  ClassType.create!(name: "Regular Class", description: "Standard classroom setting", is_archived: false),
  ClassType.create!(name: "Advanced Placement", description: "College-level curriculum and examinations", is_archived: false),
  ClassType.create!(name: "Honors", description: "More challenging coursework for high-achieving students", is_archived: false),
  ClassType.create!(name: "Special Education", description: "Tailored instruction for students with special needs", is_archived: false),
  ClassType.create!(name: "Elective", description: "Optional courses outside core curriculum", is_archived: false),
  ClassType.create!(name: "Remedial", description: "Extra help for struggling students", is_archived: true)
]

# Create themes (subjects)
themes = [
  Theme.create!(module_name: "Mathematics", module_description: "Advanced Mathematics", is_archived: false),
  Theme.create!(module_name: "Physics", module_description: "General Physics", is_archived: false),
  Theme.create!(module_name: "Chemistry", module_description: "Organic Chemistry", is_archived: false),
  Theme.create!(module_name: "Biology", module_description: "Cell Biology", is_archived: false),
  Theme.create!(module_name: "Literature", module_description: "World Literature", is_archived: false),
  Theme.create!(module_name: "History", module_description: "World History", is_archived: false),
  Theme.create!(module_name: "Geography", module_description: "Human Geography", is_archived: false),
  Theme.create!(module_name: "Computer Science", module_description: "Programming and Algorithms", is_archived: false),
  Theme.create!(module_name: "Art", module_description: "Fine Arts and Visual Design", is_archived: false),
  Theme.create!(module_name: "Music", module_description: "Music Theory and Performance", is_archived: false),
  Theme.create!(module_name: "Physical Education", module_description: "Sports and Health", is_archived: true),
  Theme.create!(module_name: "Foreign Languages", module_description: "Spanish, French, and German", is_archived: false)
]

# Create classrooms - across different quarters and types
classrooms = []

# Current quarter classrooms (4)
4.times do |i|
  classrooms << Classroom.create!(
    name: "Class #{i+1}A",
    teacher: teachers[i % teachers.size],
    class_type: class_types[i % class_types.size],
    room: rooms[i],
    quarter: current_quarter,
    is_archived: false
  )
end

# Next quarter classrooms (4)
4.times do |i|
  classrooms << Classroom.create!(
    name: "Class #{i+1}B",
    teacher: teachers[i % teachers.size],
    class_type: class_types[i % class_types.size],
    room: rooms[i+4],
    quarter: next_quarter,
    is_archived: false
  )
end

# Past quarter classroom (2)
2.times do |i|
  classrooms << Classroom.create!(
    name: "Class #{i+1}C",
    teacher: teachers[(i+2) % teachers.size],
    class_type: class_types[(i+2) % class_types.size],
    room: rooms[i],
    quarter: past_quarter,
    is_archived: true
  )
end

# Winter quarter (2)
2.times do |i|
  classrooms << Classroom.create!(
    name: "Class #{i+1}D",
    teacher: teachers[(i+4) % teachers.size],
    class_type: class_types[(i+1) % class_types.size],
    room: rooms[i+2],
    quarter: winter_quarter,
    is_archived: false
  )
end

# Create students - good and struggling across classrooms
good_students = []
struggling_students = []
average_students = []

# Function to create student
def create_student(first_name, last_name, email, classroom, state)
  user = User.create!(
    email: email,
    password: "password",
    password_confirmation: "password",
    first_name: first_name,
    last_name: last_name
  )
  user.add_role(:student)
  Student.create!(
    user: user,
    classroom: classroom,
    state: state,
    is_archived: false
  )
end

# Good student names
good_first_names = ["Alice", "Benjamin", "Claire", "David", "Emily", "Franklin", "Grace", "Henry", "Isabel", "Jack"]
good_last_names = ["Anderson", "Baker", "Chen", "Davis", "Edwards", "Fisher", "Garcia", "Harris", "Ibrahim", "Johnson"]

# Struggling student names
struggling_first_names = ["Olivia", "Peter", "Quinn", "Ryan", "Sofia", "Tyler", "Uma", "Victor", "Wendy", "Xavier"]
struggling_last_names = ["Kim", "Lopez", "Martinez", "Nelson", "O'Connor", "Parker", "Rodriguez", "Smith", "Thomas", "Wilson"]

# Average student names
average_first_names = ["Abigail", "Brandon", "Charlotte", "Daniel", "Elizabeth", "Fernando", "Gabriella", "Harrison", "Isabella", "Jason"]
average_last_names = ["Allen", "Brown", "Clark", "Diaz", "Evans", "Flores", "Green", "Hernandez", "Ingram", "Jones"]

# Create 30 good students (average >= 4.0) across current classrooms
30.times do |i|
  classroom = classrooms[i % 4] # Spread across 4 current classrooms
  good_students << create_student(
    good_first_names[i % 10], 
    good_last_names[i % 10] + (i/10 + 1).to_s,
    "good_student#{i+1}@example.com",
    classroom,
    :active
  )
end

# Create 25 struggling students (average < 4.0) across current classrooms
25.times do |i|
  classroom = classrooms[i % 4] # Spread across 4 current classrooms
  struggling_students << create_student(
    struggling_first_names[i % 10],
    struggling_last_names[i % 10] + (i/10 + 1).to_s,
    "struggling_student#{i+1}@example.com",
    classroom,
    :active
  )
end

# Create 15 average students (mix of grades) across current classrooms
15.times do |i|
  classroom = classrooms[i % 4] # Spread across 4 current classrooms
  average_students << create_student(
    average_first_names[i % 10],
    average_last_names[i % 10] + (i/10 + 1).to_s,
    "average_student#{i+1}@example.com",
    classroom,
    :active # All students are active, no inactive state
  )
end

# Create 10 students in past classrooms (archived)
10.times do |i|
  classroom = classrooms[8 + (i % 2)] # Past classrooms (indices 8 and 9)
  Student.create!(
    user: User.create!(
      email: "past_student#{i+1}@example.com",
      password: "password",
      password_confirmation: "password",
      first_name: ["Alex", "Bailey", "Casey", "Dakota", "Evan", "Finley", "Greer", "Harper", "Indigo", "Jordan"][i],
      last_name: ["Martin", "Thompson", "Walker", "White", "Young", "Scott", "Lee", "Hill", "Moore", "Turner"][i]
    ).tap { |u| u.add_role(:student) },
    classroom: classroom,
    state: :active,
    is_archived: true
  )
end

# Weekly schedule template
weekday_slots = {
  monday: ["08:00-09:30", "10:00-11:30", "13:00-14:30", "15:00-16:30"],
  tuesday: ["09:00-10:30", "11:00-12:30", "14:00-15:30"],
  wednesday: ["08:00-09:30", "10:00-11:30", "13:00-14:30", "15:00-16:30"],
  thursday: ["09:00-10:30", "11:00-12:30", "14:00-15:30"],
  friday: ["08:00-09:30", "10:00-11:30", "13:00-14:30"]
}

# Create courses for each classroom
classrooms.each_with_index do |classroom, classroom_index|
  next if classroom.is_archived
  
  # Skip some classrooms to create variety
  next if classroom_index > 8 # Only create courses for the first 9 classrooms

  # Select appropriate quarter
  quarter = classroom.quarter
  
  # Choose random themes for this classroom
  classroom_themes = themes.sample(5)
  
  # Assign courses throughout the week
  weekday_slots.each do |weekday, time_slots|
    time_slots.sample(rand(2..3)).each do |time_slot|
      start_time, end_time = time_slot.split('-')
      
      # Skip some slots randomly
      next if rand < 0.2 # 20% chance of skipping a slot
      
      Course.create!(
        start_time: Time.parse(start_time),
        end_time: Time.parse(end_time),
        weekday: weekday,
        quarter: quarter,
        theme: classroom_themes.sample,
        classroom: classroom,
        teacher: [classroom.teacher, teachers.sample].sample, # Sometimes different from classroom teacher
        is_archived: false
      )
    end
  end
end

# Create grades for each student in their courses
puts "\nCreating grades..."

# Helper method to create grades for a student
def create_grades_for_student(student, grade_range)
  # Find all courses for the student's classroom
  courses = student.classroom.courses.not_archived

  # Skip if no courses
  return if courses.empty?
  
  # Create 1-3 grades per course for the student
  courses.each do |course|
    rand(1..3).times do
      Grade.create!(
        student: student,
        teacher: course.teacher,
        course: course,
        grade: rand(grade_range).round(1),
        grading_date: rand(course.quarter.start_date..course.quarter.end_date),
        is_archived: false
      )
    end
  end
end

# Create grades for good students (4.0 to 6.0)
good_students.each do |student|
  create_grades_for_student(student, 4.0..6.0)
end

# Create grades for struggling students (2.0 to 3.9)
struggling_students.each do |student|
  create_grades_for_student(student, 2.0..3.9)
end

# Create grades for average students (mix of 3.0 to 5.5)
average_students.each do |student|
  create_grades_for_student(student, 3.0..5.5)
end

puts "Created #{Grade.count} grades"
puts "Created #{Student.count} students (#{good_students.count} good, #{struggling_students.count} struggling, #{average_students.count} average)"
puts "Created #{Teacher.count} teachers"
puts "Created #{Course.count} courses"
puts "Created #{Classroom.count} classrooms"
puts "Created #{Room.count} rooms"
puts "Created #{Quarter.count} quarters"
puts "Created #{Theme.count} themes"
puts "Created #{ClassType.count} class types"

puts "Seeding completed!"
