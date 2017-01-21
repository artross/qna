FactoryGirl.define do
  factory :attachment_to_question, class: "Attachment" do
    sequence(:file) { |n| "File #{n}" }
    association :attachable, factory: :question
  end

  factory :attachment_to_answer, class: "Attachment" do
    sequence(:file) { |n| "File #{n}" }
    association :attachable, factory: :answer
  end
end
