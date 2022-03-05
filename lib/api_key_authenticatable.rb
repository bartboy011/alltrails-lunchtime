# frozen_string_literal: true

module ApiKeyAuthenticatable
  include ActionController::HttpAuthentication::Token::ControllerMethods

  attr_reader :current_user

  # Will automatically return a 401 if the API Key does not produce a user
  def authenticate_with_api_key!
    @current_user = authenticate_or_request_with_http_token(&method(:authenticate_key))
  end

  private

  attr_writer :current_user

  def authenticate_key(token, _options)
    ApiKey.find_by(token:)&.user
  end
end
