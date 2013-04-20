class ApplicationController < ActionController::Base
  protect_from_forgery

  def current_store
    Store.find_by_subdomain!(request.subdomain)
  rescue ActiveRecord::RecordNotFound
    return nil
  end
  helper_method :current_store

  def active_and_not_pending_cancelation
    !current_store.try(:subscription).try(:active?) || current_store.try(:subscription).try(:pending_cancelation?)
  end
  helper_method :active_and_not_pending_cancelation

end
