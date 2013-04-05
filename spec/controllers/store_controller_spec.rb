require 'spec_helper'
require 'database_cleaner'

describe StoresController do
  let(:user) { FactoryGirl.create(:user) }
  let(:store) { FactoryGirl.create(:store, :user_id => user.id) }

  before(:each) do
    @request.host = "#{store.database}.lvh.me"
    scope_to_store(store)
  end
end
