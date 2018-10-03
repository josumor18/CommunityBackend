json.extract! message, :id, :id_chat, :id_user, :message, :seen, :created_at, :updated_at
json.url message_url(message, format: :json)
