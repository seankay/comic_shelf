require 'spec_helper'

describe "Registration Process" do
  
  let(:store) { FactoryGirl.create(:store)}

  subject { page }

  before do
    set_host "lvh.me:3000"
    visit root_path
    click_link "Free Trial"
  end

  it "should have correct path" do
    current_path.should eq(new_store_path)
  end

  describe "Store creation" do

    context "valid" do
      it "should redirect to user registration path after creating store" do
        within("#new_store") do
          fill_in "store_name", with: "Sample Store"
        end
        click_button 'Create Store'
        current_path.should eq(signup_path)
      end
    end

    context "invliad" do
      it "should show errors if store duplication is attempted" do
        within("#new_store") do
          fill_in "store_name", with: store.name
        end
        click_button "Create Store"
        page.should have_content("error")
      end

      it "should show errors if invalid store name is provided" do
        within("#new_store") do
          fill_in "store_name", with: ".--!"
        end
        click_button "Create Store"
        page.should have_content("error")
      end

      it "should show errors if store name is too short" do
        within("#new_store") do
          fill_in "store_name", with: "1"
        end
        click_button "Create Store"
        page.should have_content("error")
      end

      it "should show errors if store name is too long" do
        within("#new_store") do
          fill_in "store_name", with: "1"*41
        end
        click_button "Create Store"
        page.should have_content("error")
      end
    end
  end

  describe "Signup", :vcr do
    let(:user){ FactoryGirl.create(:user, :store_id => store.id)}
    before do 
      visit signup_url(:subdomain => store.subdomain)
      @email = "test@example.com"
    end
    
    context "valid" do
      before do
        seed_plans
        within("#new_user") do
          fill_in "user_email", with: @email
          fill_in "user_password", with: user.password
          fill_in "user_password_confirmation", with: user.password
        end
        click_button "Sign up"
      end

      it "should redirect to store upon valid registration" do
        current_url.should eq("http://#{store.subdomain}.lvh.me:3000#{spree_path}")
      end

      it "should assign correct roles to user" do
        roles = User.find_by_email(@email).spree_roles
        roles.pluck(:name).should include("admin")
      end
    end

    context "invalid" do
      it "should show errors if user already exists" do
        within("#new_user") do
          fill_in "user_email", with: user.email
          fill_in "user_password", with: user.password
          fill_in "user_password_confirmation", with: user.password
        end
        click_button "Sign up"
        page.should have_content("error")
      end

      it "should show errors if password doesn't match" do
        within("#new_user") do
          fill_in "user_email", with: @email
          fill_in "user_password", with: user.password 
          fill_in "user_password_confirmation", with: "foobar312"
        end
        click_button "Sign up"
        page.should have_content("error")
      end
    end
  end
end
