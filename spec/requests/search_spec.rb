require 'rails_helper'

RSpec.describe "Search", type: :request do
  def create_user
    User.create! email: 'irrelevant', password: 'irrelevant'
  end

  describe "POST /search" do
    it "returns 401 with missing authentication" do
      post "/search"

      expect(response).to have_http_status(:unauthorized)
    end

    it "returns 401 with invalid authentication" do
      headers = { 'Authorization': 'Bearer somethingmadeup' }
      post "/search", headers: headers

      expect(response).to have_http_status(:unauthorized)
    end

    it "returns 2xx with valid authentication" do
      user = create_user
      headers = { 'Authorization': "Bearer #{user.api_key.token}" }
      post "/search", headers: headers
      
      expect(response).to have_http_status(:success)
    end
  end
end
