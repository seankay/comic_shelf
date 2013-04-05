FactoryGirl.define do
  factory :subscription do
    sequence :email do |n|
      "test#{n}@example.com"
    end
    plan
    store
  end
end
