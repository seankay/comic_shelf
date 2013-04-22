require 'spec_helper'

describe SubscriptionsController do
  
  let(:store){ FactoryGirl.create(:store)}
  let(:low_plan){ FactoryGirl.create(:low_plan) }
  let(:new_plan){ FactoryGirl.create(:mid_plan) }
  let(:new_subscription ){ FactoryGirl.build(:subscription, :plan => new_plan) }
  
  before do
    @subscription = FactoryGirl.create(:subscription, store: store, plan: low_plan)
    Subscription.stub(:find).and_return(@subscription)
    @subscription.stub(:cancel_subscription).and_return(true)
    @subscription.stub(:update_subscription).and_return(true)
    Subscription.stub(:find).and_return(@subscription)
    request.host = "lvh.me"
    @user = FactoryGirl.build(:user, store: store)
    controller.stub(:user_signed_in?).and_return(true)
    controller.stub(:authenticate_user!).and_return(true)
    controller.stub(:spree_current_user).and_return(@user)
    register_and_login_user @user 
    ResqueSpec.reset!
  end

  describe "POST Update", :vcr, :record => :new_episodes do
    it "should email subscription information"
      # post :update, id: @subscription.id, subscription: new_subscription, store_id: store.id, plan_id: new_subscription.plan.id
      # response.code.should eq(200)
      # UserMailer.should have_queued(@subscription.id)
  end

  describe "DELETE Destroy", :vcr, :record => :new_episodes do
    it "should email subscription cancelation confirmation" do
      delete :destroy, id: @subscription.id, subscription: @subscription, store_id: store.id
      UserMailer.should have_queue_size_of 1
    end

    it "should redirect to shop" do
      delete :destroy, id: @subscription.id, subscription: @subscription, store_id: store.id
      response.should redirect_to store_plans_path(store)
    end
  end
end
