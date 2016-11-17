FactoryGirl.define do
  factory :answer do
    sequence(:body) { |n| "Answer #{n}"}
    question
    author
  end

  factory :invalid_answer, class: Answer do
    body nil
    question
    author
  end
end
