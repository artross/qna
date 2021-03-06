FactoryGirl.define do
  sequence(:email) { |n| "user#{n}@test.com" }

  factory :user, aliases: [:author] do
    email
    password "111111"
    password_confirmation "111111"
  end
end
