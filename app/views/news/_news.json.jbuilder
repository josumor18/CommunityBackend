json.extract! news, :id, :idCommunity, :title, :description, :date, :photo, :approved, :created_at, :updated_at
json.url news_url(news, format: :json)
