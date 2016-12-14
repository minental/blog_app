FactoryGirl.define do
  factory :user do
    sequence(:name) { |n| "user#{n}" }
    sequence(:email) { |n| "user#{n}@example.com" }
    password "qwerty"
    password_confirmation "qwerty"
    trait :admin do
      role 2
    end
  end

  factory :post do
    title "post1"
    content "post1"
    user
  end

  factory :comment do
    content "comment1"
    post
  end
end