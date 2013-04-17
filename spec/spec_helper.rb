require 'rubygems'
require 'database_cleaner'
require 'capybara/poltergeist'

Capybara.javascript_driver = :poltergeist

STRIPE_API_KEY = ENV['STRIPE_API_KEY']

ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'

require 'capybara/rails'
require 'capybara/rspec'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

VCR.configure do |c|
  c.cassette_library_dir = Rails.root.join("spec", "vcr")
  c.hook_into :webmock
end

RSpec.configure do |config|

  config.treat_symbols_as_metadata_keys_with_true_values = true

  config.around(:each, :vcr) do |example|
    name = example.metadata[:full_description].split(/\s+/, 2).join("/").underscore.gsub(/[^\w\/]+/, "_")
    options = example.metadata.slice(:record, :match_requests_on).except(:example_group)
    VCR.use_cassette(name, options) { example.call }
  end

  config.include Rails.application.routes.url_helpers
  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  #Database Cleanup for Schemas
  config.before(:suite)do
    DatabaseCleaner.clean_with :truncation
  end

  config.before(:each)do
    DatabaseCleaner.strategy = :transaction
  end

  config.before(:each, :js => true) do
    DatabaseCleaner.strategy = :truncation
  end

  config.before(:each) do
    GC.disable
    DatabaseCleaner.start
  end

  config.after(:each)do
    # Store.all.each do |store|
    #   Apartment::Database.drop(store.database)
    # end
    GC.enable
    DatabaseCleaner.clean
  end

  config.use_transactional_fixtures = false
  config.infer_base_class_for_anonymous_controllers = false
  config.order = "random"
end

def set_host (host)
  default_url_options[:host] = host
  Capybara.app_host = "http://" + host
end

def scope_current_store(&block)
  return unless @current_store
  @current_store.scope_schema("public", &block)
end

def clean_up_tables(store, klass)
  scope_to_store(store)
  klass.delete_all
end

def scope_to_store(store)
  DatabaseUtility.switch(store.subdomain)
end

def reset_scope
  DatabaseUtility.switch
end

def login user
  visit spree.login_url(:subdomain => user.store.subdomain)
  fill_in "Email", with: user.email
  fill_in "Password", with: user.password
  click_button "Login"
end    

def register_and_login_user user
  register_user user
  login user
end

def register_user(user)
  scope_to_store user.store
  user.save!
  user.set_roles(["admin"])
end

def test_card_token
  "tok_1X642XUE6V0FrB"
end

def test_invalid_card
  "42424242424242422"
end

def test_customer(params={})
  {
    :subscription_history => [],
    :bills => [],
    :charges => [],
    :livemode => false,
    :object => "customer",
    :id => "cus_1YWxXSPn82empY",
    :active_card => {
    :type => "Visa",
    :last4 => "4242",
    :exp_month => 11,
    :country => "US",
    :exp_year => 2012,
    :id => "cc_test_card",
    :object => "card",
    :subscription => {
      :trial_end => Time.now + 5.days
    },
  },
    :created => 1304114758
  }.merge(params)
end

def test_invalid_api_key_error
  {
    "error" => {
    "type" => "invalid_request_error",
    "message" => "Invalid API Key provided: invalid"
  }
  }
end

def test_invalid_exp_year_error
  {
    "error" => {
    "code" => "invalid_expiry_year",
    "param" => "exp_year",
    "type" => "card_error",
    "message" => "Your card's expiration year is invalid"
  }
  }
end

def test_missing_id_error
  {
    :error => {
    :param => "id",
    :type => "invalid_request_error",
    :message => "Missing id"
  }
  }
end

def seed_plans
  [:low_plan, :mid_plan, :high_plan].each do |plan|
    FactoryGirl.create(plan)
  end
end
