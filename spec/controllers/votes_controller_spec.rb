require 'rails_helper'

RSpec.describe VotesController, type: :controller do
  describe "POST #create" do
    log_user_in

    before { @value = rand(2) * 2 - 1  } # -1 or 1

    context "for each votable type" do
      it "assigns correct @votable" do
        [:question, :answer].each do |votable_type|
          votable = create(votable_type)

          post :create, params: { vote: { votable_id: votable, votable_type: votable.class.name, value: @value }, format: :json }
          expect(assigns(:votable)).to eq(votable)
        end
      end

      it "changes votable's rating correctly" do
        [:question, :answer].each do |votable_type|
          votable = create(votable_type)

          post :create, params: { vote: { votable_id: votable, votable_type: votable.class.name, value: @value }, format: :json }
          expect(votable.reload.rating).to eq(@value)
        end
      end
    end

    context "for some votable type" do
      let(:votable_type) { [:question, :answer].sample }
      let(:votable) { create(votable_type) }

      context "persists a vote" do
        it "increases its author's votes count (current user)" do
          expect do
            post :create, params: { vote: { votable_id: votable, votable_type: votable.class.name, value: @value }, format: :json }
          end.to change(@user.votes, :count).by(1)
        end

        it "increases its votable's votes count" do
          expect do
            post :create, params: { vote: { votable_id: votable, votable_type: votable.class.name, value: @value }, format: :json }
          end.to change(votable.votes, :count).by(1)
        end
      end

      it "renders JSON in OK response" do
        post :create, params: { vote: { votable_id: votable, votable_type: votable.class.name, value: @value }, format: :json }

        expect(response).to have_http_status :success
        expect { JSON.parse(response.body) }.not_to raise_error
      end

      it "renders extra fields in JSON" do
        post :create, params: { vote: { votable_id: votable, votable_type: votable.class.name, value: @value }, format: :json }
        expect(response).to have_http_status :success

        votable.reload
        response_hash = JSON.parse(response.body)
        expect(response_hash["rating"]).to eq(votable.rating)
        expect(response_hash["votes"]).to eq(votable.votes.count)
        expect(response_hash["region"]).to eq("#{votable_type}#{votable.id}")
        expect(response_hash["action"]).to eq("vote")
        expect(response_hash["vote_value"]).to eq(@value)
        expect(response_hash["vote_id"]).to eq(votable.votes.first.id)
      end
    end

    it "fails with author's own votable" do
      votable = create(:answer, author: @user)

      post :create, params: { vote: { votable_id: votable, votable_type: votable.class.name, value: @value }, format: :json }
      expect(response).to have_http_status :forbidden
    end
  end

  describe "DELETE #destroy" do
    log_user_in

    context "for each votable type" do
      it "changes votable's rating correctly" do
        [:question, :answer].each do |votable_type|
          vote = create("vote_for_#{votable_type}")
          votable = vote.votable

          delete :destroy, params: { id: vote.id, vote: { votable_id: votable, votable_type: votable.class.name }, format: :json }
          expect(votable.reload.rating).to eq(0)
        end
      end
    end

    context "for some votable type" do
      let(:votable_type) { [:question, :answer].sample }
      let(:vote) { create("vote_for_#{votable_type}", author: @user) }
      let!(:votable) { vote.votable }

      context "removes a vote from DB" do
        it "decreases author's votes count" do
          expect do
            delete :destroy, params: { id: vote.id, vote: { votable_id: votable, votable_type: votable.class.name }, format: :json }
          end.to change(@user.votes, :count).by(-1)
        end

        it "decreases votable's votes count" do
          expect do
            delete :destroy, params: { id: vote.id, vote: { votable_id: votable, votable_type: votable.class.name }, format: :json }
          end.to change(votable.votes, :count).by(-1)
        end
      end

      it "renders JSON in OK response" do
        delete :destroy, params: { id: vote.id, vote: { votable_id: votable, votable_type: votable.class.name }, format: :json }

        expect(response).to have_http_status :success
        expect { JSON.parse(response.body) }.not_to raise_error
      end

      it "renders extra fields in JSON" do
        delete :destroy, params: { id: vote.id, vote: { votable_id: votable, votable_type: votable.class.name }, format: :json }
        expect(response).to have_http_status :success

        votable.reload
        response_hash = JSON.parse(response.body)
        expect(response_hash["rating"]).to eq(votable.rating)
        expect(response_hash["votes"]).to eq(votable.votes.count)
        expect(response_hash["region"]).to eq("#{votable_type}#{votable.id}")
        expect(response_hash["action"]).to eq("unvote")
      end
    end
  end
end
