FactoryGirl.define do
  factory :vote do
    user nil
    post nil
  end
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
    sequence(:title) { |n| "title#{n}" }
    sequence(:content) { |n| "post#{n}" }
    user
  end

  factory :comment do
    sequence(:content) { |n| "comment#{n}" }
    post
  end
end