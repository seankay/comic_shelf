require 'spec_helper'

describe "Admin Dashboard" do
  let(:subscription) { FactoryGirl.build(:subscription) }
  let(:store) { FactoryGirl.create(:store)}
  subject { page }

  before do 
    store.subscription = subscription
    seed_plans
    clean_up_tables(store, User)
    register_and_login_user FactoryGirl.build(:user, :store_id => store.id)
    click_link "Dashboard"
    click_link "Configuration"
  end

  describe "Configuration", :vcr do
    describe "Side Menu" do
      it "should have subscription menu" do
        page.should have_link("Subscription", edit_store_subscription_path(store, store.subscription) )
      end
    end
  end
end
