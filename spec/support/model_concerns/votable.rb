require 'rails_helper'

shared_examples_for "votable" do
  it { should have_many(:votes).dependent(:destroy) }
  it { should accept_nested_attributes_for :votes }

  context "#user_vote_value" do
    let(:vote) { create(:vote_for_question) }
    let(:answer) { create(:answer) }

    it "knows user's vote value if voted" do
      votable = vote.votable
      expect(votable.user_vote_value(vote.author)).to eq(vote.value)
    end

    it "returns 0 if user didn't vote yet" do
      expect(answer.user_vote_value(answer.author)).to eq(0)
    end
  end

  context "#user_vote_id" do
    let(:vote) { create(:vote_for_answer) }
    let(:question) { create(:question) }

    it "returns correct vote id" do
      votable = vote.votable
      expect(votable.user_vote_id(vote.author)).to eq(vote.id)
    end

    it "returns 0 if no votes exist" do
      expect(question.user_vote_id(question.author)).to eq(0)
    end
  end
end
