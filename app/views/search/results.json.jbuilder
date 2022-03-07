# frozen_string_literal: true

json.array! @results do |result|
  json.name result["name"]
  json.address result["formatted_address"]
  json.location result["geometry"]["location"]
  json.photo result["photo"]
  json.rating result["rating"]
  json.ratings_count result["user_ratings_total"]
  json.favorite result["favorite"]
end
