require 'rails_helper'

RSpec.describe AnswersController, type: :controller do

  describe 'POST #best_answer' do
    log_user_in
    let(:question) { create(:question, author: @user) }
    let(:answer1) { create(:answer, question: question, best_answer: false) }
    let(:answer2) { create(:answer, question: question, best_answer: true) }

    it 'sets the answer to be "the best answer"' do
      post :best_answer, params: { question_id: question, id: answer1, format: :js }
      answer1.reload
      expect(answer1.best_answer).to be true
    end

    it 'changes the best answer, prohibiting multiple "best answers"' do
      answer2
      post :best_answer, params: { question_id: question, id: answer1, format: :js }
      answer2.reload
      expect(answer2.best_answer).to be false
    end
  end

  describe 'POST #create' do
    log_user_in
    let(:question) { create(:question, author: @user) }

    context 'with valid answer' do
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

  describe 'PATCH #update' do
    log_user_in
    let(:old_answer_body) { answer.body }

    context "with an author's answer's" do
      let!(:question) { create(:question, author: @user) }
      let!(:answer) { create(:answer, question: question, author: @user) }

      context 'valid changes' do
        it "doesn't add or remove any answers" do
          expect do
            patch :update, params: { question_id: question, id: answer, answer: { body: "Edited body" }, format: :js }
          end.not_to change(Answer, :count)
        end

        it 'persists an updated answer' do
          patch :update, params: { question_id: question, id: answer, answer: { body: "Edited body" }, format: :js }
          answer.reload
          expect(answer.body).to eq "Edited body"
        end

        it "renders update.js template" do
          patch :update, params: { question_id: question, id: answer, answer: { body: "Edited body" }, format: :js }
          expect(response).to render_template :update
        end
      end

      context 'invalid changes' do
        it "doesn't persist an answer" do
          patch :update, params: { question_id: question, id: answer, answer: { body: '' }, format: :js }
          answer.reload
          expect(answer.body).to eq old_answer_body
        end

        it "renders update.js template" do
          patch :update, params: { question_id: question, id: answer, answer: { body: '' }, format: :js }
          expect(response).to render_template :update
        end
      end
    end

    context "with another's answer" do
      log_user_in
      let!(:question) { create(:question) }
      let!(:answer) { create(:answer, question: question) }

      it "doesn't persist an answer" do
        patch :update, params: { question_id: question, id: answer, answer: { body: "Edited body" }, format: :js }
        answer.reload
        expect(answer.body).to eq old_answer_body
      end

      it "re-renders parent's question's show view" do
        patch :update, params: { question_id: question, id: answer, answer: { body: '' }, format: :js }
        expect(response).to render_template :'questions/show'
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
        expect { delete :destroy, params: { question_id: question, id: answer, format: :js } }.to change(Answer, :count).by(-1)
      end

      it "renders destroy.js template" do
        delete :destroy, params: { question_id: question, id: answer, format: :js }
        expect(response).to render_template :destroy
      end
    end

    context "with another's answer" do
      let(:answer) { create(:answer, question: question) }

      it "doesn't remove an answer from DB" do
        answer
        expect { delete :destroy, params: { question_id: question, id: answer, format: :js } }.not_to change(Answer, :count)
      end

      it "re-renders parent's question's show view" do
        delete :destroy, params: { question_id: question, id: answer, format: :js }
        expect(response).to render_template :'questions/show'
      end
    end
  end
end
