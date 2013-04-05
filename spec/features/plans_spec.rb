require 'spec_helper'

describe "Plans" do
  subject { page }

  let(:low_plan) { FactoryGirl.create(:low_plan)}
  let(:mid_plan) { FactoryGirl.create(:mid_plan)}
  let(:high_plan) { FactoryGirl.create(:high_plan)}

  before do 
    @plans = [low_plan, mid_plan, high_plan]
    @store = Store.create!(FactoryGirl.attributes_for(:store))
    subscription = Subscription.new(
      :email => "test@example.com",
      :plan_id => Plan.find_by_plan_identifier("low_plan").id,
    )
    subscription.trial_end_date = Time.now + 14.days
    @store.subscription = subscription
    user = FactoryGirl.create(:user, :store_id => @store.id)
    visit login_url(:subdomain => user.store.subdomain)
    fill_in "Email", with: user.email
    fill_in "Password", with: user.password
    click_button "Sign in"
    visit store_plans_url(@store, :subdomain => @store.subdomain)
  end

  describe "Page" do
    it "should have plans listed" do
      @plans.each do |plan|
        should have_link("Subscribe")
        should have_selector("div##{plan.id}")
        should have_selector("p", text: "#{plan.max_products}")
        should have_selector("p", text: "#{plan.price}")
        should have_selector("p", text: "#{plan.name}")
        should have_link("Subscribe")
      end
    end

    describe "Elements" do
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
    end
  end
end
