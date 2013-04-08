source 'https://rubygems.org'
ruby '1.9.3'

gem 'rails', '3.2.13'
gem 'pg'

group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'uglifier', '>= 1.0.3'
  gem 'bootstrap-sass', '~> 2.3.1.0'
end

gem 'jquery-rails', '2.2.0'

group :test, :development do
  gem "rspec-rails"
  gem "shoulda-matchers"
  gem "pry"
end

group :test do
  gem "capybara", '~> 2.0.3'
  gem "factory_girl_rails"
  gem 'database_cleaner'
  gem 'vcr'
  gem 'webmock', '< 1.10.0'
  gem 'poltergeist'
  gem 'resque_spec'
end

gem "figaro", '~> 0.6.3'
gem 'cancan', '= 1.6.8'
gem "devise", '~> 2.2.3'
gem 'apartment', path: '../apartment' 
gem 'spree', '1.3.2'
gem 'spree_gateway', :github => 'spree/spree_gateway', :branch => '1-3-stable'
gem 'stripe'
gem 'resque', :github => 'resque/resque', :branch => '1-x-stable'
gem 'resque-scheduler', :require => 'resque_scheduler'
