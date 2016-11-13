FactoryGirl.define do
  factory :question do
    title "MyString"
    body "MyText"

    factory :question_with_answers do
      transient do
        answers_count 2
      end

      after(:create) do |question, factory|
        create_list(:answer, factory.answers_count, question: question)
      end
    end
  end

  factory :invalid_question, class: Question do
    title nil
    body nil
  end
end
