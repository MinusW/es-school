json.extract! student, :id, :user_id, :classroom_id, :state, :is_archived, :created_at, :updated_at
json.url student_url(student, format: :json)
