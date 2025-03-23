json.extract! classroom, :id, :name, :class_type_id, :room_id, :teacher_id, :is_archived, :created_at, :updated_at
json.url classroom_url(classroom, format: :json)
