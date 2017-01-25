FactoryGirl.define do
  factory :vote_for_question, class: "Vote" do
    value 1
    author
    association :votable, factory: :question
  end

  factory :vote_for_answer, class: "Vote" do
    value -1
    author
    association :votable, factory: :answer
  end
end
