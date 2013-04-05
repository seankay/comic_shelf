class SubscriptionsController < ApplicationController
  before_filter :authenticate_user!

  def show
    @subscription = Subscription.find(params[:id])
  end

  def edit
    @plan = Plan.find(params[:plan_id])
    @subscription = current_store.subscription
    @subscription.plan = @plan
  end

  def update
    @subscription = current_store.subscription
    if params[:subscription]
      new_subscription = Subscription.new(params[:subscription])
    else
      new_subscription = Subscription.new(plan_id: params[:plan_id], email:current_user.email)
    end

    if @subscription.update_subscription new_subscription
      current_store.subscription = @subscription
      redirect_to spree_url(:subdomain => current_store.subdomain),
        notice: "Successfully subscribed to #{@subscription.plan.name}!"
    else
      redirect_to store_plans_path(current_store),
        error: "Error. Unable to subscribe."
    end
  end

  def destroy
    @subscription = current_store.subscription
    if @subscription.cancel_subscription
      redirect_to spree_url(:subdomain => current_store.subdomain), :notice => "Your subscription has been cancelled."
    else
      redirect_to store_plans_path(current_store), :error => "Unable to remove your subscription. Please contact support for assistance."
    end
  end

end
