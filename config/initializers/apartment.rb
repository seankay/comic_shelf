Apartment.configure do |config|
  #List of schemas
  config.database_names = lambda { Store.pluck(:subdomain) }

  #List of excluded models
  config.excluded_models = ["Store", "Subscription", "Plan"]
end
