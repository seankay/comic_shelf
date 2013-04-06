FactoryGirl.define do
  factory :subscription do
    sequence :email do |n|
      "test#{n}@example.com"
    end
    plan
    store
  end
  factory :subscription_without_card do
    sequence :email do |n|
      "test#{n}@example.com"
    end
    stripe_card_token = nil
    plan
    store
  end
end
