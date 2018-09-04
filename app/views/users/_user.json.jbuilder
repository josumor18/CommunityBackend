json.extract! user, :id, :name, :email, :password, :cel, :tel, :address, :photo, :photo_thumbnail, :isPrivate, :auth_token, :created_at, :updated_at
json.url user_url(user, format: :json)
