json.extract! community_member, :id, :id_community, :id_user, :isAdmin, :created_at, :updated_at
json.url community_member_url(community_member, format: :json)
