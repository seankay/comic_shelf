FactoryGirl.define do
  factory :store do
    sequence :name do |n|
      "store#{n}"
    end
    sequence :subdomain do |n|
      "store#{n}"
    end
  end
end
