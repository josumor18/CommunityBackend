json.extract! community, :id, :name, :description, :rules, :isSubcommunity, :photo, :photo_thumbnail, :sub_communities, :created_at, :updated_at
json.url community_url(community, format: :json)
