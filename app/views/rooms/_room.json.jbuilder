json.extract! room, :id, :name, :building, :floor, :capacity, :is_archived, :created_at, :updated_at
json.url room_url(room, format: :json)
