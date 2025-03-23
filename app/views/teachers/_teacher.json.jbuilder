json.extract! teacher, :id, :IBAN, :state, :is_dean, :is_archived, :user_id, :created_at, :updated_at
json.url teacher_url(teacher, format: :json)
