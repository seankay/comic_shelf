require 'spec_helper'

describe "Store" do
  
  subject { page }

  let(:subscription){ FactoryGirl.create(:subscription) }
  let(:new_subscription){ FactoryGirl.create(:subscription_with_card) }
  let(:store){ FactoryGirl.create(:store) }

  describe "Page", :vcr, :record => :new_episodes do
    before do
      set_host "lvh.me:3000"
      seed_plans
      user = FactoryGirl.build(:user)
      store.subscription = subscription
      user.store = store
      register_and_login_user user
    end
    it "should not show dashboard selection for non-admins"
    it "should show dashboard selection for non-admins"
    it "should show subscribe link if current subscription is not active or pending cancelation" do
      should have_link("Subscribe")
    end

  end
end
