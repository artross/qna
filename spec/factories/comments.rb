FactoryGirl.define do
  factory :comment_for_question, class: "Comment" do
    sequence(:body) { |n| "Comment #{n}" }
    author
    association :commentable, factory: :question
  end

  factory :comment_for_answer, class: "Comment" do
    sequence(:body) { |n| "Comment #{n}" }
    author
    association :commentable, factory: :answer
  end
end
