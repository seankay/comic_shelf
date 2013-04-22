require 'spec_helper'

describe "Admin Dashboard" do
  let(:store) { FactoryGirl.create(:store)}
  let(:subscription) { FactoryGirl.create(:subscription) }
  subject { page }

  before do 
    seed_plans
    clean_up_tables(store, Spree::User)
    Spree::HomeController.any_instance.stub(:current_store) { store }
    Store.any_instance.stub(:subscription) { subscription } 
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
