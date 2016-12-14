FactoryGirl.define do
  factory :user do
    name "user"
    email "user@example.com"
    password "qwerty"
    password_confirmation "qwerty"
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