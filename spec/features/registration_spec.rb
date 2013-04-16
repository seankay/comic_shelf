require 'spec_helper'

describe "Registration Process" do

  subject { page }

  before do
    set_host "lvh.me:3000"
    visit root_path
  end

  describe "Store Signup", :vcr do
    let(:store) { FactoryGirl.create(:store)}
    let(:user){ FactoryGirl.create(:user, :store_id => store.id)}
    let(:valid_email){ "test@example.com" }
    let(:test_store){ FactoryGirl.build(:store) }
    before do 
      visit root_path
    end

    context "valid registration" do
      before do
        seed_plans
        within("#registration_form") do
          fill_in "store_name", with: test_store.name
          fill_in "user_email", with: valid_email
          fill_in "user_password", with: user.password
        end
        click_button "Get Started!"
      end

      it "should redirect to store upon valid registration" do
        current_url.should eq("http://#{test_store.subdomain}.lvh.me:3000#{spree_path}")
      end

      it "should assign correct roles to user" do
        roles = User.find_by_email(valid_email).spree_roles
        roles.pluck(:name).should include("admin")
      end
    end

    context "invalid registration" do
      it "should show errors if store duplication is attempted" do
        within("#registration_form") do
          fill_in "store_name", with: store.name
          fill_in "user_email", with: valid_email
          fill_in "user_password", with: user.password
        end
        click_button "Get Started!"
        page.should have_selector(".alert")
      end

      it "should show errors if invalid store name is provided" do
        within("#registration_form") do
          fill_in "store_name", with: ".--!"
          fill_in "user_email", with: valid_email
          fill_in "user_password", with: user.password
        end
        click_button "Get Started!"
        page.should have_selector(".alert")
      end

      it "should show errors if store name is too short" do
        within("#registration_form") do
          fill_in "store_name", with: "1"
          fill_in "user_email", with: valid_email
          fill_in "user_password", with: user.password
        end
        click_button "Get Started!"
        page.should have_selector(".alert")
      end

      it "should show errors if store name is too long" do
        within("#registration_form") do
          fill_in "store_name", with: "1"*41
          fill_in "user_email", with: valid_email
          fill_in "user_password", with: user.password
        end
        click_button "Get Started!"
        page.should have_selector(".alert")
      end
    end
  end

  describe "User Signup" do
    context "valid"
    context "invalid"
  end
end
