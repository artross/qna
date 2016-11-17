FactoryGirl.define do
  sequence(:title) { |n| "Title #{n}" }
  sequence(:body) { |n| "Body #{n}" }

  factory :question do
    title
    body
    author

    factory :question_with_answers do
      transient do
        answers_count 2
      end

      after(:create) do |question, factory|
        create_list(:answer, factory.answers_count, question: question, author: question.author)
      end
    end
  end

  factory :invalid_question, class: Question do
    title nil
    body nil
    author
  end
end
