require 'spec_helper'

describe Plan do

  let(:plan){ FactoryGirl.create(:plan)}
  subject { plan }

  describe "Attributes" do
    it { should respond_to(:name)}
    it { should respond_to(:price)}
    it { should respond_to(:max_products)}
    it { should respond_to(:plan_identifier)}
  end

  describe "Relations" do
    it { should have_many(:subscriptions)}
  end
end
