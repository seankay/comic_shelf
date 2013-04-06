source 'https://rubygems.org'

gem 'rails', '3.2.13'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

gem 'pg'


# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  # gem 'therubyracer', :platforms => :ruby

  gem 'uglifier', '>= 1.0.3'
  gem 'bootstrap-sass', '~> 2.3.1.0'
end

gem 'jquery-rails', '2.2.0'

# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# To use Jbuilder templates for JSON
# gem 'jbuilder'

# Use unicorn as the app server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'debugger'

group :test, :development do
  gem "rspec-rails"
  gem "guard-rspec"
  gem "shoulda-matchers"
  gem "faker"
  gem "pry"
end

group :development do
  gem "better_errors"
  gem "binding_of_caller"
  gem "meta_request", "0.2.1"
  gem "sextant"
  gem 'letter_opener'
end

group :test do
  gem "capybara", '~> 2.0.3'
  gem "rb-fsevent"
  gem "growl"
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
