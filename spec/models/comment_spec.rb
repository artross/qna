require 'rails_helper'

RSpec.describe Comment, type: :model do
  it { should validate_presence_of :body }
  it { should belong_to :commentable }
  it_behaves_like "authorable"

  describe "#question" do
    it "gets right question from question's comment" do
      question = create(:question)
      comment = create(:comment_for_question, commentable: question)

      expect(comment.question).to eq question
    end

    it "gets right question from answer's comment" do
      answer = create(:answer)
      comment = create(:comment_for_answer, commentable: answer)

      expect(comment.question).to eq answer.question
    end
  end
end
