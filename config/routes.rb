# frozen_string_literal: true

Rails.application.routes.draw do
  post "favorites/save"
  post "/search", to: "search#search"
end
