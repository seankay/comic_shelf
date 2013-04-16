class HomeController < ApplicationController
  layout "home"

  def index
    sign_out current_user if current_user
    @store = Store.new
  end

end
