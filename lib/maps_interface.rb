class MapsInterface
  def initialize(conn = nil)
    @conn = conn || client_factory
  end

  def search(input = "")
    if ENV["GOOGLE_MAPS_PRIMARY_LOCATION"].nil?
      raise "You are missing the required latitude and longitude to search near."
    end

    response = @conn.get("textsearch/json",
      {
        location: ENV["GOOGLE_MAPS_PRIMARY_LOCATION"],
        type: "restaurant",
        opennow: "true",
        query: input
      })

    return nil unless response.success?

    response.body["results"].map { |r| enrich_with_photo_url(r) }
  end

  private

  def client_factory
    if ENV["GOOGLE_API_KEY"].nil?
      raise "You are missing the required Google Maps API Key."
    end

    Faraday.new(
      url: "https://maps.googleapis.com/maps/api/place",
      params: {
        key: ENV["GOOGLE_API_KEY"]
      }
    ) do |f|
      f.response :json # decode response bodies as JSON
      f.response :logger # decode response bodies as JSON
      f.adapter :net_http # use the NetHTTP adapter
    end
  end

  def enrich_with_photo_url(result)
    first_photo = result["photos"].shift
    if first_photo.nil?
      result["photo"] = nil
      return result
    end

    # To prevent bombarding the photos API, and adding a ton of latency,
    # lets cache image results where we can
    cache_key = "image/" + result["name"].gsub(/\s+/, "-")
    result["photo"] = Rails.cache.fetch(cache_key, expires_in: 12.hours) do
      response = @conn.get(
        "photo",
        query: {maxwidth: 256, photo_reference: first_photo["photo_reference"]}
      )

      "data:#{response.headers["content-type"]};base64," + Base64.strict_encode64(response.body)
    end
    result
  end
end
