json.array!(@tickets) do |ticket|
  json.extract! ticket, :id, :created_at, :updated_at, :key, :uid, :displayname, :skill, :served
  json.url ticket_url(ticket, format: :json)
end
