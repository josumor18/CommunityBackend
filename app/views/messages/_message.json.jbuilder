json.extract! message, :id, :id_chat, :message, :sent, :created_at, :updated_at
json.url message_url(message, format: :json)
