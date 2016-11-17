require 'rails_helper'

RSpec.describe AnswersController, type: :controller do

  describe 'GET #index' do
    let(:question) { create(:question) }
    before { get :index, params: { question_id: question } }

    it 'assigns parent question' do
      expect(assigns(:question)).to eq question
    end

    it "redirects to parent question's show view" do
      expect(response).to redirect_to(question_path(question))
    end
  end

  describe 'POST #create' do
    log_user_in
    let(:question) { create(:question, author: @user) }

    context 'with valid object' do
      it 'persists an object' do
        question
        expect do
          post :create, params: { question_id: question, answer: attributes_for(:answer) }
        end.to change(Answer, :count).by(1)
      end

      # couldn't figure out how to test this through change()
      it 'links an object with its assosiated parent' do
        post :create, params: { question_id: question, answer: attributes_for(:answer) }
        expect(assigns(:answer).question).to eq(question)
      end

      it "redirects to parent question's show view" do
        post :create, params: { question_id: question, answer: attributes_for(:answer) }
        expect(response).to redirect_to(question_path(assigns(:question)))
      end
    end

    context 'with invalid object' do
      it "doesn't persist an object" do
        question

        expect do
          post :create, params: { question_id: question, answer: attributes_for(:invalid_answer) }
        end.not_to change(Answer, :count)
      end

      it "redirects to parent question's show view" do
        post :create, params: { question_id: question, answer: attributes_for(:answer) }
        expect(response).to redirect_to(question_path(assigns(:question)))
      end
    end
  end

  describe 'DELETE #destroy' do
    log_user_in
    let(:question) { create(:question, author: @user) }
    let(:answer) { create(:answer, question: question, author: @user) }

    it 'removes object from DB' do
      answer
      expect { delete :destroy, params: { question_id: question, id: answer } }.to change(Answer, :count).by(-1)
    end

    it 'redirects to index view' do
      delete :destroy, params: { question_id: question, id: answer }
      expect(response).to redirect_to question_path(question)
    end
  end
end
