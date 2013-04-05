class PlansController < ApplicationController
  before_filter :authenticate_user!

  def index
    @plans = Plan.order("price")
    @subscription = current_store.subscription
  end
end
