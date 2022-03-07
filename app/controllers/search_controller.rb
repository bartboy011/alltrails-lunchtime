# frozen_string_literal: true

class SearchController < ApplicationController
  include ApiKeyAuthenticatable

  prepend_before_action :authenticate_with_api_key!

  def search
    @results = MapsInterface.new.search(search_params)
    if @results.nil?
      raise "There was an error connecting to the Maps API, please try again."
    end

    # the Favorites table has a unique index on user_id, restaurant_name. Given
    # that these are the only two columns we need, let's specifically request them.
    # This will enable most SQL engines to use a covering index, e.g. pull the requested
    # data directly from the index rather than needing to first look up the record in the index
    # and then pull the data from the table
    FavoritesEnricher.enrich(@results, current_user.favorites.select(:user_id, :restaurant_name))

    render "results"
  end

  private

  # Will return a string, not a hash, since there's only the one param
  def search_params
    params.require(:search)
  end
end
