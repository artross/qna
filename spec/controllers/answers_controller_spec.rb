require 'rails_helper'

RSpec.describe AnswersController, type: :controller do

  describe 'POST #create' do
    log_user_in
    let(:question) { create(:question, author: @user) }

    context 'with valid answer' do
      # Is it possible to DRY out this kind of tests? Or the ones like in DELETE #destroy?
      it 'persists an answer with its assosiated question' do
        question
        expect do
          post :create, params: { question_id: question, answer: attributes_for(:answer), format: :js }
        end.to change(question.answers, :count).by(1)
      end

      it 'persists an answer with its assosiated author' do
        question
        expect do
          post :create, params: { question_id: question, answer: attributes_for(:answer), format: :js }
        end.to change(@user.answers, :count).by(1)
      end

      it "renders create.js template" do
        post :create, params: { question_id: question, answer: attributes_for(:answer), format: :js }
        expect(response).to render_template :create
      end
    end

    context 'with invalid answer' do
      it "doesn't persist an answer" do
        question

        expect do
          post :create, params: { question_id: question, answer: attributes_for(:invalid_answer), format: :js }
        end.not_to change(Answer, :count)
      end

      it "renders create.js template" do
        post :create, params: { question_id: question, answer: attributes_for(:answer), format: :js }
        expect(response).to render_template :create
      end
    end
  end

  describe 'DELETE #destroy' do
    log_user_in
    let(:question) { create(:question) }

    context "with an author's answer" do
      let(:answer) { create(:answer, question: question, author: @user) }

      it 'removes an answer from DB' do
        answer
        expect { delete :destroy, params: { question_id: question, id: answer } }.to change(Answer, :count).by(-1)
      end

      it "redirects to parent's question's show view" do
        delete :destroy, params: { question_id: question, id: answer }
        expect(response).to redirect_to question_path(question)
      end
    end

    context "with another's answer" do
      let(:answer) { create(:answer, question: question) }

      it "doesn't remove an answer from DB" do
        answer
        expect { delete :destroy, params: { question_id: question, id: answer } }.not_to change(Answer, :count)
      end

      it "redirects to parent's question's show view" do
        delete :destroy, params: { question_id: question, id: answer }
        expect(response).to render_template :'questions/show'
      end
    end
  end
end
