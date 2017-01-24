require 'rails_helper'

RSpec.describe VotesController, type: :controller do
  describe "POST #create" do
    log_user_in

    before { @value = rand(2) * 2 - 1  } # -1 or 1

    it "persists a vote with it's associated votable" do
      # here it's NOT important which model will represent votable
      votable = create(:question)

      expect do
        post :create, params: { vote: { votable_id: votable, votable_type: votable.class.name, value: @value }, format: :json }
      end.to change(votable.votes, :count).by(1)
    end

    it "persists a vote with it's associated author (current user)" do
      # here it's also NOT important which model will represent votable
      votable = create(:answer)

      expect do
        post :create, params: { vote: { votable_id: votable, votable_type: votable.class.name, value: @value }, format: :json }
      end.to change(@user.votes, :count).by(1)
    end

    it "assigns correct @votable" do
      # here it IS important to check all of the votables possible
      [:question, :answer].each do |votable_type|
        votable = create(votable_type)

        post :create, params: { vote: { votable_id: votable, votable_type: votable.class.name, value: @value }, format: :json }
        expect(assigns(:votable)).to eq(votable)
      end
    end

    it "changes votable's rating correctly" do
      # here it IS also important to check all of the votables possible
      [:question, :answer].each do |votable_type|
        votable = create(votable_type)

        post :create, params: { vote: { votable_id: votable, votable_type: votable.class.name, value: @value }, format: :json }
        expect(votable.reload.rating).to eq(@value)
      end
    end

    it "returns JSON in response"
  end

  describe "DELETE #destroy" do
    log_user_in

    it "removes a vote from DB"
    it "changes votable's rating correctly"
    it "returns JSON in response"
  end
end
