require 'spec_helper'

describe "Home Page" do
  
  subject { page }

  before do 
    set_host "lvh.me:3000"
    visit root_url
  end

  it "should show registration form" do
    should have_selector("#new-customer")
  end

  it "should have navigation bar" do
    should have_selector(".navbar")
  end

  describe "Pricing Page" do
    before do 
      seed_plans
      click_link "Pricing"
    end

    it "Should list plan pricing" do
      should have_content("Try ComicShelf free for 14 days!")
    end
  end
end
