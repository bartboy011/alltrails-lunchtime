# frozen_string_literal: true

class SearchController < ApplicationController
  include ApiKeyAuthenticatable

  prepend_before_action :authenticate_with_api_key!

  def search
    @results = [{name: "test"}, {name: "test2"}]
    render "results"
  end
end
