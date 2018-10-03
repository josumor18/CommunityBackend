json.extract! chat, :id, :id_community, :is_group, :created_at, :updated_at
json.url chat_url(chat, format: :json)
