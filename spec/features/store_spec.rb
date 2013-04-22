require 'spec_helper'

describe "Store" do
  
  subject { page }

  let(:store){ FactoryGirl.create(:store) }
  let(:subscription){ FactoryGirl.create(:subscription, store: store) }
  let(:new_subscription){ FactoryGirl.create(:subscription_with_card) }

  describe "Page", :vcr, :record => :new_episodes do
    before do
      set_host "lvh.me:3000"
      seed_plans
      user = FactoryGirl.build(:user)
      user.store = store
      user.store.subscription = subscription
      register_and_login_user user
    end
    it "should not show dashboard selection for non-admins"
    it "should show dashboard selection for non-admins"
  end
end
