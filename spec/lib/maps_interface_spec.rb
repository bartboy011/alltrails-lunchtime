require "rails_helper"

RSpec.describe MapsInterface do
  before(:each) do
    ENV["GOOGLE_API_KEY"] = "apikey"
    ENV["GOOGLE_MAPS_PRIMARY_LOCATION"] = "something"
    @stubs = Faraday::Adapter::Test::Stubs.new(strict_mode: true)
    @faraday = Faraday.new("https://example.org") do |builder|
      builder.adapter :test, @stubs
    end
    @maps_instance = MapsInterface.new(@faraday)
  end

  it "should raise an error if the API key is missing" do
    ENV["GOOGLE_API_KEY"] = nil

    expect { MapsInterface.new }.to raise_error(RuntimeError, MapsInterface.api_missing_key_error_string)
  end

  it "should raise an error if the primary location is missing" do
    ENV["GOOGLE_MAPS_PRIMARY_LOCATION"] = nil

    expect { MapsInterface.new.search }.to raise_error(RuntimeError, MapsInterface.api_missing_primary_location_error_string)
  end

  it "includes the required params in its GET to google apis" do
    @stubs.get(
      "https://example.org/textsearch/json?query=irrelevant&location=something&opennow=true&type=restaurant"
    ) { |env| [200, {}, {"results" => []}] }
    @maps_instance.search("irrelevant")
  end

  it "returns nil if the google API returns a non-success code" do
    ENV["GOOGLE_MAPS_PRIMARY_LOCATION"] = "something"

    @stubs.get(
      "https://example.org/textsearch/json?query=irrelevant&location=something&opennow=true&type=restaurant"
    ) { |env| [400, {'Content-Type': "application/json"}, "[]"] }

    expect(@maps_instance.search("irrelevant")).to be_nil
  end

  it "enriches results with photo urls" do
    reference = "abiglongstring"
    @stubs.get(
      "https://example.org/textsearch/json?query=irrelevant&location=something&opennow=true&type=restaurant"
    ) { |env| [200, {}, {"results" => [{"name" => "something", "photos" => [{"photo_reference" => reference}]}]}] }
    @stubs.get(
      "https://example.org/photo?maxwidth=256&photo_reference=#{reference}"
    ) { |env| [200, {"content-type" => "image/png"}, "png image bytes"] }

    expect(@maps_instance.search("irrelevant")[0]["photo"]).to include("data:image/png;base64,")
  end
end
