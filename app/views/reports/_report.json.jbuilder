json.extract! report, :id, :id_comment, :id_user, :reason, :created_at, :updated_at
json.url report_url(report, format: :json)
