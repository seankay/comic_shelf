require 'spec_helper'

describe "Store" do
  
  subject { page }

  let(:store){ FactoryGirl.create(:store) }
  let(:subscription){ FactoryGirl.create(:subscription, store: store) }
  let(:new_subscription){ FactoryGirl.create(:subscription_with_card) }

  describe "Page", :vcr, :record => :new_episodes do
    before do
      Spree::HomeController.any_instance.stub(:current_store) { store }
      Store.any_instance.stub(:subscription) { subscription } 
      set_host "lvh.me:3000"
      seed_plans
      user = FactoryGirl.build(:user)
      user.store = store
      user.store.subscription = subscription
      register_and_login_user user
    end

    after do 
      Spree::Config[:logo] = nil
      Spree::Config[:site_name] = ENV['APPLICATION_NAME']
    end

    it "should not show dashboard selection for non-admins" do
      non_admin = FactoryGirl.build(:user)
      register_and_login_user non_admin
      non_admin.spree_roles = []
      visit current_url
      should_not have_link("Dashboard")
    end

    it "should show dashboard selection for admins" do
      should have_link("Dashboard")
    end

    it "should show store name if logo is not present" do
      Spree::Config[:logo] = nil
      Spree::Config[:site_name] = store.name
      visit current_url
      should have_selector("h1", text: store.name)
    end

    it "should not show store name if logo is present" do
      Spree::Config[:logo] = "path/to/logo"
      visit current_url
      should_not have_selector("h1", text: store.name)
    end
  end
end
