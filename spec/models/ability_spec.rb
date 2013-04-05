require 'spec_helper'
require 'cancan/matchers'

describe "User Abilities" do

  subject { ability }
  let(:ability) { Ability.new(user)}
  let(:user) { nil }

  describe "Admin" do
    let(:user){ FactoryGirl.create(:admin)}
  end

  describe "Trial User" do
    let(:user){ FactoryGirl.create(:trial_user)}
  end

  describe "Regular User" do
    let(:user){ FactoryGirl.create(:user)}
  end

end
