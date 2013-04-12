require 'spec_helper'

describe "Store" do
  
  subject { page }

  let(:subscription){ FactoryGirl.create(:subscription) }
  let(:new_subscription){ FactoryGirl.create(:subscription_with_card) }

  describe "Page", :vcr, :record => :new_episodes do
    before do
      seed_plans
      register_user FactoryGirl.build(:user, :store_id => FactoryGirl.create(:store).id)
      subscription.save_without_payment
      subscription.update_subscription new_subscription
    end
    it "should not show dashboard selection for non-admins"
    it "should show dashboard selection for non-admins"
    it "should show subscribe link if current subscription is not active or pending cancelation" do
      subscription.cancel_subscription
      should have_link("Subscribe")
    end

  end
end
