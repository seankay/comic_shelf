require 'spec_helper'

describe SubscriptionsController do
  
  let(:store){ FactoryGirl.create(:store)}
  let(:low_plan){ FactoryGirl.create(:low_plan) }
  let(:new_plan){ FactoryGirl.create(:mid_plan) }
  let(:new_subscription ){ FactoryGirl.build(:subscription, :plan => new_plan) }
  let(:subscription){ FactoryGirl.build(:subscription, :store => store,:plan => low_plan) }
  let(:user){ FactoryGirl.create(:user, :store => store)}
  
  before do
    request.host = "#{store.subdomain}.lvh.me:3000"
    controller.stub(:authenticate_user!).and_return(true)
    controller.stub(:current_user).and_return(user)
    subscription.stripe_customer_token = test_customer[:id]
    subscription.save!
    @double_subscription = mock(Subscription)
    ResqueSpec.reset!
  end

  describe "POST Update", :vcr, :record => :new_episodes do
    before do
      @double_subscription.stub(:update_subscription).and_return(true)
      post :update, id: subscription.id, subscription: new_subscription, store_id: store.id, plan_id: new_subscription.plan.id
    end
    it "should email subscription information" do
      UserMailer.should have_queue_size_of 1
    end
  end

  describe "DELETE Destroy", :vcr, :record => :new_episodes do
    before do
      @double_subscription.stub(:cancel_subscription).and_return(true)
      delete :destroy, id: subscription.id, subscription: subscription, store_id: store.id
    end

    it "should email subscription cancelation confirmation" do
      UserMailer.should have_queue_size_of 1
    end

    it "should redirect to shop" do
      response.should redirect_to spree_url(:host => "lvh.me:3000",:subdomain => store.subdomain)
    end
  end
end
