require 'spec_helper'
require 'database_cleaner'
require 'spree/core/testing_support/factories/product_factory'
include Spree

describe Store do

  let(:store) { FactoryGirl.create(:store) }
  let(:user) { FactoryGirl.create(:user) }
  let(:store2) { FactoryGirl.create(:store)}
  subject { store }

  describe "Attributes" do
    it { should respond_to(:name)}
    it { should have_many(:spree_users)}
    it { should have_one(:subscription)}

    describe "name" do

      it "should be unique" do
        expect { Store.create!({:name => store.name}) }.to raise_error
      end

      it "should not exceed 40 characters" do
        Store.new({:name =>  "a"*41 }).should_not be_valid
      end

      it "should not be valid" do
        Store.new({:name => "...--,','"}).should_not be_valid
      end

      it "should not have non-alphanumeric characters and should be lowercased for subdomain" do
        store.subdomain.should eq(store.name.gsub(/[^0-9a-zA-Z]/, "").downcase)
      end

    end
  end

  describe "Schemas" do
    describe Store do
      it "should be in public schema" do
        reset_scope
        Store.create(FactoryGirl.attributes_for(:store))
        Store.count.should eq 1
        Store.create(FactoryGirl.attributes_for(:store))
        Store.count.should eq 2
      end
    end

    describe User do

      it "should have isolated schemas" do
        scope_to_store(store)
        store.spree_users << user
        User.count.should eq 1
        scope_to_store(store2)
        User.count.should eq 0
        reset_scope
        User.count.should be_zero
      end
    end

    describe "Products" do
      it "should have isolated schemas" do
        scope_to_store(store)
        expect{Spree::Product.create!({
          :name      => "Store1",
          :permalink => "store1-perma-link",
          :price     => "1"
        })}.to change{Product.count}.from(0).to(1)
        scope_to_store(store2)
        expect{Spree::Product.create!({
          :name      => "Store2",
          :permalink => "store2-perma-link",
          :price     => "2"
        })}.to change{Product.count}.from(0).to(1)
        reset_scope
        Product.count.should be_zero
      end
    end
  end
end
