# Be sure to restart your server when you modify this file.

ComicShelf::Application.config.session_store :cookie_store, key: '_comic_shelf_session'

#Devise keep session between subdomain
ComicShelf::Application.config.session_store :cookie_store, key: '_application_devise_session', domain: :all, tld_length: 2


# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rails generate session_migration")
# ComicShelf::Application.config.session_store :active_record_store
