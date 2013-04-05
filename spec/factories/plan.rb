FactoryGirl.define do
  factory :plan do
    name "no plan"
    price 0
    max_products 0
    plan_identifier "no_plan"

    factory :low_plan do
      name "Low Plan"
      price 10
      max_products 1
      plan_identifier "low_plan"
    end
    factory :mid_plan do
      name "Mid Plan"
      price 25
      max_products 5
      plan_identifier "mid_plan"
    end
    factory :high_plan do
      name "High Plan"
      price 50
      max_products 10
      plan_identifier "high_plan"
    end
  end
end
