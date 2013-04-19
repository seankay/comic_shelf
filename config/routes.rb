require 'resque/server'

ComicShelf::Application.routes.draw do


  devise_scope :user do
    post '/create_with_store', :to => "spree/user_registrations#create_with_store"
    match '/shop/user/logout', :to => "spree/user_sessions#destroy"
  end

  resources :stores do
    resources :subscriptions do
      post 'update_credit_card'
      get 'edit_credit_card'
    end
    resources :plans, :only => :index
  end

  match '', to: 'stores#show', constraints: lambda { |r| r.subdomain.present? && r.subdomain != 'www' }
  mount Resque::Server.new, :at => "/resque"
  mount Spree::Core::Engine, :at => '/shop', constraints: lambda { |r| r.subdomain.present? && r.subdomain != 'www' }
  root to: 'home#index'
end
