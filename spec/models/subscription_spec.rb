require 'spec_helper'
require 'resque_spec/scheduler'

describe Subscription do 

  let(:new_plan){ FactoryGirl.create(:mid_plan) }
  let(:low_plan){ FactoryGirl.create(:low_plan) }
  let(:subscription){ FactoryGirl.build(:subscription, :plan => low_plan) }
  let(:new_subscription ){ FactoryGirl.build(:subscription, :plan => new_plan) }
  let(:invalid_subscription){ Subscription.new(email:"test@example.com") }
  let(:invalid_plan){  
    Plan.create!(
      name: "invalid plan",
      plan_identifier: "invalid_plan",
      price: 1,
      max_products: 0
  )
  }
  let(:invalid_subscription_with_invalid_plan){ 
    Subscription.new(
      :email => "test@example.com",
      :plan_id => Plan.find_by_plan_identifier("invalid_plan")
  )
  }

  subject{ subscription }

  before do
    new_subscription.stripe_card_token = test_card_token
    subscription.stripe_customer_token = test_customer[:id]
    subscription.plan = low_plan
    invalid_subscription_with_invalid_plan.plan = invalid_plan
  end

  describe "Attributes" do
    it { should respond_to(:email)}
    it { should respond_to(:stripe_customer_token)}
  end

  describe "Relations" do
    it { should belong_to(:plan)}
  end

  describe "Methods" do
    describe "active?", :vcr do
      it "should return false if card is not provided or is on trial" do
        subscription.save_without_payment
        subscription.active?.should be_false
      end

      it "should return true if card is provided" do
        subscription
      end
    end

    describe "trial?" do
      it "should return true if current date is <= trial_end_date " do
        subscription.trial_end_date = Time.now+1.day
        subscription.trial?.should be_true
      end

      it "should return false if current_date is > trial_end_date" do
        subscription.trial_end_date = Time.now-1.day
        subscription.trial?.should be_false
      end

      it "should return false if card is provided" do
        subscription.card_provided = true
        subscription.trial?.should be_false
      end
    end

    describe "save_without_payment", :vcr do
      before { ResqueSpec.reset! }

      it "should store customer data on successful trial subscription" do
        count = Subscription.count
        expect{subscription.save_without_payment}.to change{Subscription.count}.from(count).to(count+1)
        subscription.card_provided.should be_false
        subscription.cancelation_date.should be_nil
      end

      it "should return false if save_without_payment fails" do
        invalid_subscription = Subscription.new(
          :email => "test@example.com",
        )
        invalid_subscription.save_without_payment.should be_false
      end

      it "should email superadmin when transaction fails" do
        invalid_subscription_with_invalid_plan.save_without_payment
        SuperAdminMailer.should have_queue_size_of 1
      end

      it "should set up trial period" do
        subscription.save_without_payment
        subscription.trial_end_date.should be_present
      end

    end

    describe "update_subscription", :vcr, :record => :new_episodes do
      before do
        ResqueSpec.reset!
      end

      it "should update subscription plan" do
        subscription.save!
        subscription.update_subscription new_subscription
        subscription.plan.should eq new_plan
      end

      it "should update card, trial_end_date, and subscription plan" do
        subscription.save!
        subscription.update_subscription new_subscription
        subscription.plan.should eq new_plan
        subscription.card_provided.should be_true
        subscription.trial_end_date.should be_present
      end

      it "should remove trial period" do
        subscription.save!
        subscription.update_subscription new_subscription
        subscription.trial?.should be_false
      end

      it "should make subscription active" do
        subscription.save!
        subscription.update_subscription new_subscription
        subscription.active?.should be_true
      end

      it "should email superadmin when transaction fails" do
        subscription.save!
        subscription.update_subscription invalid_subscription_with_invalid_plan
        SuperAdminMailer.should have_queue_size_of 1
      end

      it "should set up trial period" do
        subscription.save_without_payment
        subscription.trial_end_date.should be_present
      end

      it "should return false if update fails" do
        invalid_subscription.update_subscription(low_plan).should be_false
      end
    end

    describe "pending_cancelation?", :vcr do
      before do
        subscription.save!
        subscription.update_subscription new_subscription
        ResqueSpec.reset!
        subscription.cancel_subscription
      end

      it "should return true if subscription is cancelled and is active" do
        subscription.pending_cancelation?.should be_true
      end

      it "should return false if subscription is updated is nil" do
        subscription.update_subscription new_subscription
        subscription.pending_cancelation?.should be_false
      end
    end

    describe "cancel_subscription", :vcr, :record => :new_episodes do

      before do
        subscription.save!
        subscription.update_subscription new_subscription
        ResqueSpec.reset!
        subscription.cancel_subscription
      end

      it "should set canceled_at value" do
        subscription.canceled_at.should be_present
      end

      it "should keep plan features until the end of the billing cycle" do
        subscription.active?.should be_true
      end

      it "should return false if canecellation fails" do
        invalid_subscription.cancel_subscription.should be_false
      end

      it "should add subscription to cancellation queue" do
        Workers::SubscriptionCanceler.should have_scheduled(subscription.id)
      end

      it "should email superadmin when transaction fails" do
        subscription.save!
        subscription.cancel_subscription
        SuperAdminMailer.should have_queue_size_of 1
      end

      it "should set up trial period" do
        subscription.save_without_payment
        subscription.trial_end_date.should be_present
      end
    end

    describe "restarting subscription", :vcr, :record => :new_episodes do
      before do
        subscription.save!
        subscription.update_subscription new_subscription
        ResqueSpec.reset!
      end

      it "should not change trial_end_date" do
        old_trial_end_date = subscription.trial_end_date
        subscription.cancel_subscription
        subscription.update_subscription new_subscription
        subscription.trial_end_date.should eq old_trial_end_date
      end
    end
  end
end
