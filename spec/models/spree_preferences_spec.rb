require 'spec_helper'

describe Spree::Config do
  before do
    @store1 = FactoryGirl.create(:store)
    @store2 = FactoryGirl.create(:store)
    @store1_name = "Store1"
    @store2_name = "Store2"

    DatabaseUtility.switch @store1.name
    Spree::Config[:site_name] = @store1_name
    DatabaseUtility.switch @store2.name
    Spree::Config[:site_name] = @store2_name
  end

  it "should have the right preference for the store" do
    DatabaseUtility.switch @store1.name
    Spree::Config.site_name.should == @store1_name
    DatabaseUtility.switch @store2.name
    Spree::Config.site_name.should == @store2_name
  end
end

describe Spree::Api::Config do
  before do
    @store1 = FactoryGirl.create(:store)
    @store2 = FactoryGirl.create(:store)

    DatabaseUtility.switch @store1.name
    Spree::Api::Config[:requires_authentication] = true
    DatabaseUtility.switch @store2.name
    Spree::Api::Config[:requires_authentication] = false
  end

  it "should have the right preference for the store" do
    DatabaseUtility.switch @store1.name
    Spree::Api::Config.requires_authentication.should == true
    DatabaseUtility.switch @store2.name
    Spree::Api::Config.requires_authentication.should == false
  end
end

describe Spree::Dash::Config do
  before do
    @store1 = FactoryGirl.create(:store)
    @store2 = FactoryGirl.create(:store)
    @store1_app_id = "App1"
    @store2_app_id = "App2"

    DatabaseUtility.switch @store1.name
    Spree::Dash::Config[:app_id] = @store1_app_id
    DatabaseUtility.switch @store2.name
    Spree::Dash::Config[:app_id] = @store2_app_id
  end

  it "should have the right preference for the store" do
    DatabaseUtility.switch @store1.name
    Spree::Dash::Config.app_id.should == @store1_app_id
    DatabaseUtility.switch @store2.name
    Spree::Dash::Config.app_id.should == @store2_app_id
  end
end
