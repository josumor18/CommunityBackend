json.extract! notification, :id, :idUser, :idContent, :created_at, :isNews, :isReports, :isEvents, :titleContent, :seen, :created_at, :updated_at
json.url notification_url(notification, format: :json)
