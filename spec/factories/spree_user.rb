FactoryGirl.define do
  factory :user, class: Spree::User do
    sequence :email do |n|
      "user#{n}@example.com"
    end
    password "foobar123"
    password_confirmation "foobar123"
    remember_me false
    factory :admin do
      spree_roles [
        Spree::Role.find_or_create_by_name("admin"),
      ]
    end
    store
  end
end
