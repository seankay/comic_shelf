class Subscription < ActiveRecord::Base
  belongs_to :plan
  belongs_to :store
  validates_presence_of :email, :plan_id

  attr_accessible :email, :plan_id, :stripe_card_token 

  attr_accessor :stripe_card_token

  def active?
    return false if trial?
    cancelation_date.nil? ? true : Time.now < cancelation_date
  end

  def trial?
    if card_provided
      false
    else
      trial_end_date.nil? ? false : Time.now <= trial_end_date
    end
  end

  def deactivate?
    !(trial? && active?)
  end

  def pending_cancelation?
    canceled_at.present? ? true : false
  end

  def save_without_payment
    if valid?
      customer = Stripe::Customer.create(email: email, plan: plan.plan_identifier)
      save_with_customer_details customer
    else
      false
    end
  rescue Stripe::InvalidRequestError => e
    logger.error "Stripe error while creating customer: #{e.message}"
    errors.add :base, "There was a problem with your registration."
    false
  end

  def update_subscription new_subscription
    if valid?
      customer = Stripe::Customer.retrieve(stripe_customer_token)
      if new_subscription.stripe_card_token.present?
        customer.update_subscription(
          :plan => new_subscription.plan.plan_identifier, 
          :card => new_subscription.stripe_card_token,
          :trial_end => "now"
        )
        self.card_provided = true
        self.trial_end_date = Time.now unless trial_end_date
        self.cancelation_date = nil
        self.canceled_at = nil
      else
        customer.update_subscription(plan: new_subscription.plan.plan_identifier)
      end
      self.plan = new_subscription.plan
      save!
    else
      false
    end
  rescue Stripe::InvalidRequestError => e
    logger.error "Stripe error while updating customer subscription: #{e.message}"
    errors.add :base, "There was a problem updating your subscription."
    false
  end

  def cancel_subscription
    if valid?
      customer = Stripe::Customer.retrieve(stripe_customer_token)
      details = customer.cancel_subscription
      if successfully_canceled? details
        save_with_cancellation_details details
      end
    else 
      false
    end
  rescue Stripe::InvalidRequestError => e
    logger.error "Stripe error while cancelling customer subscription: #{e.message}"
    errors.add :base, "There was a problem canelling your subscription."
    false
  end

  private
  
  def save_with_customer_details customer
    self.trial_end_date = convert_to_date(customer.subscription.trial_end)
    self.stripe_customer_token = customer.id
    save!
  end

  def save_with_cancellation_details details
      self.canceled_at = convert_to_date(details.canceled_at)
      self.cancelation_date = convert_to_date details.current_period_end
      Resque.enqueue_at(convert_to_date(cancelation_date), Workers::SubscriptionCanceler, id)
      save!
  end

  def successfully_canceled? details
    ["cancelled", "canceled"].include? details.status
  end
  
  def convert_to_date timestamp
    Time.zone.at(timestamp)
  end
end
