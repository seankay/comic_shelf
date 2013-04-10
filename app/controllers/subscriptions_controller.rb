class SubscriptionsController < ApplicationController
  before_filter :authenticate_user!

  def show
    @subscription = Subscription.find(params[:id])
  end

  def edit
    @subscription = Subscription.find(params[:id])
    @plan = Plan.find(params[:plan_id])
    @subscription.plan = @plan 
  end

  def update
    @subscription = Subscription.find(params[:id])
    if params[:subscription]
      updated_subscription = new_paying_subscription(params[:subscription])
    else
      updated_subscription = update_paying_subscription(params["plan_id"], current_user.email)
    end

    if @subscription.update_subscription updated_subscription
      current_store.subscription = @subscription
      UserMailer.update_subscription(@subscription.id).deliver
      redirect_to spree_url(:subdomain => current_store.subdomain),
        notice: "Successfully subscribed to #{@subscription.plan.name}!"
    else
      redirect_to store_plans_path(current_store),
        error: "Error. Unable to subscribe."
    end
  end

  def destroy
    @subscription = Subscription.find(params[:id])
    if @subscription.cancel_subscription
      UserMailer.cancel_subscription(@subscription.id).deliver
      redirect_to spree_url(:subdomain => current_store.subdomain), :notice => "Your subscription has been cancelled."
    else
      redirect_to store_plans_path(current_store), :error => "Unable to remove your subscription. Please contact support for assistance."
    end
  end

  private

  def new_paying_subscription subscription
    new_subscription = Subscription.new(subscription)
  end

  def update_paying_subscription plan_id, email
    Subscription.new(plan_id: plan_id, email:email)
  end
end
