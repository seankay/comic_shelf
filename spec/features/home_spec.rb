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
end
