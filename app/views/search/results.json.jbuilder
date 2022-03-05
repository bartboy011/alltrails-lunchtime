# frozen_string_literal: true

json.array! @results do |result|
  json.name result[:name]
end
