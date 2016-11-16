require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question) { create(:question_with_answers) }

  describe 'GET #index' do
    before { get :index, params: { question_id: question } }

    it 'assigns parent question' do
      expect(assigns(:question)).to eq question
    end

    it "redirects to parent question's show view" do
      expect(response).to redirect_to(question_path(question))
    end
  end

  describe 'GET #new' do
    log_user_in
    before { get :new, params: { question_id: question } }

    it 'assigns parent question' do
      expect(assigns(:question)).to eq question
    end

    it 'creates a new answers' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it 'creates a new answer for the parent question' do
      expect(assigns(:answer).question).to eq question
    end

    it 'renders new view' do
      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do
    log_user_in
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

      it 're-renders new view' do
        post :create, params: { question_id: question, answer: attributes_for(:invalid_answer) }
        expect(response).to render_template :new
      end
    end
  end
end
