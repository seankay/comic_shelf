require 'spec_helper'

Capybara.register_driver :poltergeist do |app|
  options = {
    :debug => true
  }
  Capybara::Poltergeist::Driver.new(app, options)
end

describe "Subscription Process" do
  subject { page }

  let(:subscription) { FactoryGirl.create(:subscription)}
  let(:store) { FactoryGirl.create(:store)}
  let(:user) {FactoryGirl.create(:user, :store_id => store.id)}

  before do 
    # @plans = Plan.all
    # set_host "#{store.subdomain}.lvh.me:3000"
    # login user
    # visit "/stores/#{store.id}/subscriptions/edit?plan_id=#{@plans.first.id}"
  end

  describe "Subscribing" do
    describe "Credit Card" do
      before do
      end

      describe "valid" do
        # it "should display success message", js: true do 
        #   scope_to_store(store)
        #   puts DatabaseUtility.current
        #   puts "TEST"
        #   login user
        #   puts current_url
        #   puts html
        #   fill_in "card_number", :with           => "4242424242424242"
        #   fill_in "card_code", :with             => "111"
        #   select "1 - January", :from            => "card_month"
        #   select "#{Date.today.year + 2}", :from => "card_year"
        #   find_button("Subscribe").trigger('click')
        #   page.should have_content("Success")
        # end
      end
      describe "invalid" do
        it "should display error message"
          # fill_in "card_number", :with           => "424242424242"
          # fill_in "card_code", :with             => "111"
          # select "1 - January", :from            => "card_month"
          # select "#{Date.today.year + 2}", :from => "card_year"
          # click_button "Subscribe"
          # page.should have_content("error")
        #end
      end
    end
  end
  describe "Unsubscribing" do
  end

  describe "Changing Tier" do
  end
end
