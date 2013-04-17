class HomeController < ApplicationController
  layout "home"

  def index
    @user = Spree::User.new
    @store = Store.new
  end

end
