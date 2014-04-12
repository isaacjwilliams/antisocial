json.(@status, :content, :created_at, :updated_at)
json.user do
  json.id @status.user_id
  json.username @status.user.profile_name
end
