class ApplicationController < ActionController::Base
  protect_from_forgery

  def current_store
    Store.find_by_subdomain!(request.subdomain)
  rescue ActiveRecord::RecordNotFound
    return nil
  end
  helper_method :current_store

end
