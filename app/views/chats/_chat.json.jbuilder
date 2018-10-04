json.extract! chat, :id, :id_community, :id_user, :is_group, :created_at, :updated_at
json.url chat_url(chat, format: :json)
