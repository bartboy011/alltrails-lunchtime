# frozen_string_literal: true

class SearchController < ApplicationController
  include ApiKeyAuthenticatable

  prepend_before_action :authenticate_with_api_key!

  def search
    @results = MapsInterface.new.search(search_params)
    render "results"
  end

  private

  # Will return a string, not a hash, since there's only the one param
  def search_params
    params.require(:search)
  end
end
