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
    if card_provided?
      false
    else
      trial_end_date.nil? ? false : Time.now <= trial_end_date
    end
  end

  def card_provided?
    card_provided
  end

  def deactivate?
    !(trial? && active?)
  end

  def pending_cancelation?
    canceled_at.present? ? true : false
  end

  def save_without_payment
    if valid?
      customer_info = Stripe::Customer.create(email: email, plan: plan.plan_identifier)
      save_with_customer_details customer_info
    else
      false
    end
  rescue Stripe::InvalidRequestError => e
    error_msg = "Stripe error while creating customer: #{e.message}"
    logger.error error_msg
    errors.add :base, "There was a problem with your registration."
    SuperAdminMailer.stripe_customer_creation_exception(self, error_msg).deliver
    false
  end

  def update_credit_card new_stripe_card_token
    if new_stripe_card_token.present?
      customer.card = new_stripe_card_token
      customer.save
      save!
    else
      false
    end
  rescue Stripe::InvalidRequestError, Stripe::CardError => e
    error_msg = "Stripe error while updating customer credit card: #{e.message}"
    logger.error error_msg
    errors.add :base, "There was a problem updating your credit card."
    SuperAdminMailer.subscription_stripe_exception(id, error_msg).deliver
    false
  end

  def update_subscription new_subscription
    if valid?
      if duplicate_plan? new_subscription
        errors.add :base, "You are already on the #{plan.name} plan."
        return false
      end

      if new_subscription.stripe_card_token.present?
        customer.update_subscription(
          :plan => new_subscription.plan.plan_identifier, 
          :card => new_subscription.stripe_card_token,
          :trial_end => "now"
        )
        self.card_provided = true
        self.trial_end_date = Time.now
      else
        customer.update_subscription(plan: new_subscription.plan.plan_identifier)
      end
      Resque.remove_delayed(Workers::SubscriptionCanceler, id) if pending_cancelation?
      self.cancelation_date = nil
      self.canceled_at = nil
      self.plan = new_subscription.plan
      save!
    else
      false
    end
  rescue Stripe::InvalidRequestError => e
    error_msg = "Stripe error while updating customer subscription: #{e.message}"
    logger.error error_msg
    errors.add :base, "There was a problem updating your subscription."
    SuperAdminMailer.subscription_stripe_exception(id, error_msg).deliver
    false
  end

  def cancel_subscription
    if valid?
      details = customer.cancel_subscription
      successfully_canceled?(details) ? save_with_cancelation_details(details) : false
    else 
      false
    end
  rescue Stripe::InvalidRequestError => e
    error_msg = "Stripe error while cancelling customer subscription: #{e.message}"
    logger.error error_msg
    errors.add :base, "There was a problem canelling your subscription."
    SuperAdminMailer.subscription_stripe_exception(id, error_msg).deliver
    false
  end

  def subscriber 
    customer
  end

  private

  def customer
    @customer ||= Stripe::Customer.retrieve(stripe_customer_token)
  end
  
  def save_with_customer_details customer
    self.trial_end_date = Time.zone.at(customer.subscription.trial_end)
    self.stripe_customer_token = customer.id
    save!
  end

  def save_with_cancelation_details details
      self.canceled_at = Time.zone.at(details.canceled_at)
      self.cancelation_date = Time.zone.at details.current_period_end
      Resque.enqueue_at(Time.zone.at(cancelation_date), Workers::SubscriptionCanceler, id)
      save!
  end

  def duplicate_plan? new_subscription
    (new_subscription.plan.id == self.plan.id) && !pending_cancelation? && active?
  end

  def successfully_canceled? details
    ["cancelled", "canceled"].include? details.status
  end
end
