Apartment.configure do |config|
  #List of schemas
  config.database_names = lambda { Store.pluck(:subdomain) }

  config.seed_after_create = true

  #List of excluded models
  config.excluded_models = ["Store", "Subscription", "Plan"]
end
