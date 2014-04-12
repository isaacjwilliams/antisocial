json.array!(@statuses) do |status|
  json.extract! status, :content
  json.user do
    json.id status.user_id
    json.username status.user.profile_name
  end
  json.url status_url(status, format: :json)
end