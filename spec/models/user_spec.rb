require 'spec_helper'

describe Spree::User do

  let(:user) { FactoryGirl.build(:user)}
  subject { user }

  describe "Attributes" do
    it { should respond_to(:email)}
    it { should respond_to(:password)}
    it { should respond_to(:password_confirmation)}
    it { should respond_to(:remember_me)}
    it { should belong_to(:store)}
  end

  describe "Relations" do
  end

  describe "Roles" do
    it "should know its role" do
      user.has_role?(:admin).should be_false
      user.spree_roles << Spree::Role.find_or_create_by_name("admin")
      user.has_role?(:admin).should be_true
    end

    describe "set_roles" do
      it "should process array of roles" do
        roles = ["admin", "trial", "superadmin"]
        user.set_roles(roles)
        roles.each do |role|
          user.has_role?(role).should be_true
        end
      end
    end
  end
end
