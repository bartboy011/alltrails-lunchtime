class FavoritesController < ApplicationController
  include ApiKeyAuthenticatable

  prepend_before_action :authenticate_with_api_key!

  def save
    current_user.favorites.create!(restaurant_name: favorite_param)
    render plain: "success"
  end

  private

  # Will return a string, not a hash, since there's only the one param
  def favorite_param
    params.require(:restaurant_name)
  end
end
