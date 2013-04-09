class SuperAdminMailer < ActionMailer::Base
  include Resque::Mailer
  @queue = :mailer

  default from: ENV["APPLICATION_EMAIL"]

  def stripe_customer_creation_exception(subscription, error_msg)
    @error_msg = error_msg
    @plan = Plan.find(subscription["subscription"]["plan_id"])
    @store = Store.find(subscription["subscription"]["store_id"])
    @email = subscription["subscription"]["email"]
    mail to: ENV["SUPER_ADMIN_EMAIL"], subject: "Stripe Exception Error - Customer Creation"
  end

  def subscription_stripe_exception(subscription_id, error_msg)
    @subscription = Subscription.find(subscription_id)
    @error_msg = error_msg
    mail to: ENV["SUPER_ADMIN_EMAIL"], subject: "Stripe Exception Error - Subscription##{subscription_id}"
  end
end
