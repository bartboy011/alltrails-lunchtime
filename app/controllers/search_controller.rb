class SearchController < ApplicationController
  include ApiKeyAuthenticatable

  prepend_before_action :authenticate_with_api_key!

  def search
    render :plain => "success"
  end
end
