class SubscriptionsController < Spree::Admin::BaseController
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
      updated_subscription = Subscription.new(params[:subscription])
    else
      updated_subscription = Subscription.new(plan_id: params["plan_id"], email:current_user.email)
    end

    if @subscription.update_subscription updated_subscription
      current_store.subscription = @subscription
      UserMailer.update_subscription(@subscription.id).deliver
      redirect_to main_app.store_plans_path, notice: "Successfully subscribed to #{@subscription.plan.name}!"
    else
      redirect_to main_app.store_plans_path(current_store), alert: @subscription.errors.full_messages.first
    end
  end

  def destroy
    @subscription = Subscription.find(params[:id])
    if @subscription.cancel_subscription
      UserMailer.cancel_subscription(@subscription.id).deliver
      redirect_to main_app.store_plans_path, :notice => "Your subscription has been cancelled."
    else
      redirect_to main_app.store_plans_path(current_store), :alert => "Unable to remove your subscription. Please contact support for assistance."
    end
  end

  def edit_credit_card
    @subscription = Subscription.find(params[:subscription_id])
  end

  def update_credit_card
    @user = params[:id]
    @subscription = Subscription.find(params[:subscription_id])
    if @subscription.update_credit_card params[:subscription][:stripe_card_token]
      redirect_to main_app.store_plans_path(current_store), notice: "Successfully updated your credit card information."
    else
      render :edit_credit_card, alert: "There was a problem updating your credit card information."
    end
  end
end
