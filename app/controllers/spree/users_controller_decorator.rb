Spree::UsersController.class_eval do

  def show
    @orders = @user.orders.complete
    @plan = current_store.subscription.plan
    subscriber = current_store.subscription.subscriber
    @credit_card = subscriber.active_card if subscriber.active_card.present?
  end
end
