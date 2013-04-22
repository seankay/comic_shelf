# Configure Spree Preferences
#
# Note: Initializing preferences available within the Admin will overwrite any changes that were made through the user interface when you restart.
#       If you would like users to be able to update a setting with the Admin it should NOT be set here.
#
# In order to initialize a setting do:
# config.setting_name = 'new value'
Spree.config do |config|
  config.site_name = ENV['APPLICATION_NAME']
end

# Spree.user_class = "User"

# Rails.application.config.to_prepare do
  # require_dependency 'spree/authentication_helpers'
# end

#enable auto capture for Stripe et al.
Spree::Config[:auto_capture] = true unless Spree::Config[:auto_capture].present?
Spree::Config[:logo] = nil
