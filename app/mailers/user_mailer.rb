class UserMailer < ActionMailer::Base
  include Resque::Mailer
  @queue = :mailer

  default from: ENV["APPLICATION_EMAIL"]

  def update_subscription id 
    @subscription = Subscription.find(id)

    mail to:@subscription.email, subject: "You've been subscribed to the #{@subscription.plan.name} plan!"
  end

  def cancel_subscription id 
    @subscription = Subscription.find(id)

    mail to:@subscription.email, subject: "Your subscription has been cancelled."
  end
end
