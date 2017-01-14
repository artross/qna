FactoryGirl.define do
  factory :attachment_to_question, class: "Attachment" do
    sequence(:file) { |n| "File #{n}" }
    association :attach_box, factory: :question
  end

  factory :attachment_to_answer, class: "Attachment" do
    sequence(:file) { |n| "File #{n}" }
    association :attach_box, factory: :answer
  end
end
