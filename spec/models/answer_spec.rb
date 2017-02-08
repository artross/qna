require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should validate_presence_of :body }
  it { should validate_presence_of :question_id }
  it { should have_db_index :question_id }
  it { should belong_to(:question) }
  it_behaves_like "authorable"
  it_behaves_like "attachable"
  it_behaves_like "votable"
  it_behaves_like "commentable"

  describe "#pick_as_best" do
    let (:question) { create(:question) }
    let (:answer) { create(:answer, question: question) }
    let (:best_answer) { create(:answer, question: question, best_answer: true) }

    it "sets the 'best_answer' property to true" do
      answer.pick_as_best
      answer.reload
      expect(answer.best_answer).to be true
    end

    it "removes the 'best answer' mark from any other question's answer" do
      best_answer
      answer.pick_as_best
      best_answer.reload
      expect(best_answer.best_answer).to be false
    end
  end
end
