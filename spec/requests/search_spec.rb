# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Search", type: :request do
  def create_user
    User.create! email: "irrelevant", password: "irrelevant"
  end

  describe "POST /search" do
    before(:each) do
      ENV["GOOGLE_MAPS_PRIMARY_LOCATION"] = "irrelevant"
      ENV["GOOGLE_API_KEY"] = "irrelevant"

      @fake_response = {
        "name" => "irrelevant",
        "formatted_address" => "irrelevant",
        "geometry" => {"location" => {latitude: 123, longitude: 123}},
        "photo" => "irrelevant",
        "rating" => 5.0,
        "user_rating_total" => 123
      }
      @mock_client = double("MapsInterface instance")
      allow(MapsInterface).to receive(:new).and_return(@mock_client)
    end

    it "returns 401 with missing authentication" do
      post "/search", params: {search: "test"}

      expect(response).to have_http_status(:unauthorized)
    end

    it "returns 401 with invalid authentication" do
      headers = {Authorization: "Bearer somethingmadeup"}
      post "/search", headers: headers, params: {search: "test"}

      expect(response).to have_http_status(:unauthorized)
    end

    it "returns 2xx with valid authentication" do
      allow(@mock_client).to receive(:search).with("test").and_return([@fake_response])
      user = create_user
      headers = {:Authorization => "Bearer #{user.api_key.token}", "ACCEPT" => "application/json"}
      post "/search", headers: headers, params: {search: "test"}

      expect(response).to have_http_status(:success)
    end

    it "renders results" do
      allow(@mock_client).to receive(:search).with("test").and_return([@fake_response])
      user = create_user
      headers = {:Authorization => "Bearer #{user.api_key.token}", "ACCEPT" => "application/json"}
      post "/search", headers: headers, params: {search: "test"}

      expect(JSON.parse(response.body)[0]["name"]).to eq(@fake_response["name"])
    end
  end
end
