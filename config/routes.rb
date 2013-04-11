require 'resque/server'

ComicShelf::Application.routes.draw do
  devise_scope :user do
    get '/login', :to => "devise/sessions#new"
    get '/signup', :to => "devise/registrations#new"
    delete '/logout', :to => "devise/sessions#destroy"
  end

  devise_for :users, controllers: { registrations: "users/registrations"}

  resources :stores do
    resources :subscriptions do
      post 'update_credit_card'
      get 'edit_credit_card'
    end
    resources :plans, :only => :index
    resources :users
  end

  match '', to: 'stores#show', constraints: lambda { |r| r.subdomain.present? && r.subdomain != 'www' }
  mount Resque::Server.new, :at => "/resque"
  mount Spree::Core::Engine, :at => '/shop', constraints: lambda { |r| r.subdomain.present? && r.subdomain != 'www' }
  root to: 'home#index'
end
