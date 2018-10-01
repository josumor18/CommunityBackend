json.extract! chat, :id, :id_community, :id_receiver, :last_message, :visto, :created_at, :updated_at
json.url chat_url(chat, format: :json)
