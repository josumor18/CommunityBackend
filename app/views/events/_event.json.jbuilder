json.extract! event, :id, :id_community, :title, :description, :dateEvent, :start, :end, :photo, :approved, :created_at, :updated_at
json.url event_url(event, format: :json)
