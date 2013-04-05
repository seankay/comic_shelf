FactoryGirl.define do
  factory :user do
    sequence :email do |n|
      "user#{n}@example.com"
    end
    password "foobar123"
    password_confirmation "foobar123"
    remember_me false
    name "User Name"
    factory :admin do
      spree_roles [
        Spree::Role.find_or_create_by_name("admin"),
        Spree::Role.find_or_create_by_name("trial")
      ]
    end
    store
  end
end
