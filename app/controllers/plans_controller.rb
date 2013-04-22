class PlansController < Spree::Admin::BaseController
  before_filter :authenticate_user!

  def index
    @plans = Plan.order("price")
    @subscription = current_store.subscription
    @credit_card = Stripe::Customer.retrieve(@subscription.stripe_customer_token).active_card
  end
end
