require 'spec_helper'

describe "Plans", :vcr, :record => :new_episodes do
  subject { page }

  let(:low_plan) { FactoryGirl.create(:low_plan)}
  let(:mid_plan) { FactoryGirl.create(:mid_plan)}
  let(:high_plan) { FactoryGirl.create(:high_plan)}
  let(:subscription){ FactoryGirl.build(:subscription, :plan => low_plan) }
  let(:new_subscription){ FactoryGirl.build(:subscription_with_card,
                                            :plan => mid_plan,
                                            :stripe_card_token => test_card_token
                                           )}

  before do 
    set_host "lvh.me:3000"
    @plans = [low_plan, mid_plan, high_plan]
    subscription.trial_end_date = Time.now + 14.days
    subscription.save_without_payment
    @store = subscription.store
    user = FactoryGirl.create(:user, :store_id => @store.id)
    visit login_url(:subdomain => user.store.subdomain)
    fill_in "Email", with: user.email
    fill_in "Password", with: user.password
    click_button "Sign in"
    visit store_plans_url(@store, :subdomain => @store.subdomain)
  end

  describe "Page" do
    it "Should not be accessible by non-admins"

    it "should have plans listed" do
      @plans.each do |plan|
        should have_link("Subscribe")
        should have_selector("p", text: "#{plan.max_products}")
        should have_selector("p", text: "#{plan.price}")
        should have_selector("h2", text: "#{plan.name}")
        should have_link("Subscribe")
      end
    end

    describe "Elements" do
      before { ResqueSpec.reset! }
      it "should have information for plan" do
        plan = low_plan
        click_link("#{plan.plan_identifier}")
        should have_selector("div.price", text: plan.price.to_s)
        should have_selector("div.name", text: plan.name)
        should have_selector("div.max_products", text: plan.max_products.to_s)
      end

      it "should have trial days left if current store is on trial subscription" do
        should have_selector("div#trial", text: "Your trial ends")
      end

      it "should display subscription days remaining if pending cancelation ", :vcr do
        subscription.update_subscription new_subscription
        subscription.cancel_subscription
        visit store_plans_url(@store, :subdomain => @store.subdomain)
        should have_content("Your subscription ends in")
      end

      it "should display 'Current Plan' if store has subscription", :vcr, :record => :new_episodes do
        subscription.update_subscription new_subscription
        visit store_plans_url(@store, :subdomain => @store.subdomain)
        should have_content("Current")
      end

      it "should not display 'Current Plan' if subscription is cancelled", :vcr, :record => :new_episodes do
        subscription.update_subscription new_subscription
        subscription.cancel_subscription
        visit store_plans_url(@store, :subdomain => @store.subdomain)
        should_not have_content("Current")
      end

    end
  end
end
