json.extract! course, :id, :start_time, :end_time, :weekday, :quarter_id, :module_id, :classroom_id, :teacher_id, :is_archived, :created_at, :updated_at
json.url course_url(course, format: :json)
