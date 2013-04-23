require 'spec_helper'

describe Spree::UserRegistrationsController do
  describe "Registration", :vcr do
    before do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      @store = FactoryGirl.build(:store)
      @user = FactoryGirl.build(:user)
      post :create_with_store, store_name: @store.name, user: {email: @user.email, password:@user.password}
    end

    describe "Store" do
      it "should create store" do
        Store.find_by_subdomain(@store.subdomain).should_not be_nil
      end
    end

    describe "User" do
      it "should create user" do
        Spree::User.find_by_email(@user.email).should_not be_nil
      end
    end

    describe "Subscription" do
      it "should create subscription" do
        Store.find_by_subdomain(@store.subdomain).subscription.should_not be_nil
      end
    end

    describe "Spree::Config" do
      it "should set default Spree Configs" do
        Spree::Config[:site_name].should eq(@store.name)
        Spree::Config[:logo].should be_empty
        Spree::Config[:default_meta_keywords].should include @store.name
        Spree::Config[:default_meta_description].should eq("#{@store.name}")
        Spree::Config[:default_seo_title].should eq("#{@store.name}")
        Spree::Config[:site_url].should eq("#{@store.name}.lvh.me:3000")
      end
    end
  end
end
