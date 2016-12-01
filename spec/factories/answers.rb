FactoryGirl.define do
  factory :answer do
    sequence(:body) { |n| "Answer #{n}"}
    best_answer false
    question
    author
  end

  factory :invalid_answer, class: Answer do
    body nil
    best_answer false
    question
    author
  end
end
