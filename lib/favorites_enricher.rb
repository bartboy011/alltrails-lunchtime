class FavoritesEnricher
  def self.enrich(results, user_favorites)
    # for each result, check if the list of user favorites has a matching entry
    results.map do |r|
      r["favorite"] = !user_favorites.index do |f|
        f.restaurant_name === r["name"]
      end.nil?
    end
  end
end
