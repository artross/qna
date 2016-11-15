require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question) { create(:question_with_answers) }

  # answers#index action is disabled due to changes in questions/show view

  # describe 'GET #index' do
  #   before { get :index, params: { question_id: question } }
  #
  #   it 'assigns parent question' do
  #     expect(assigns(:question)).to eq question
  #   end
  #
  #   it 'assigns array of answers for the parent question' do
  #     expect(assigns(:answers)).to match_array(question.answers)
  #   end
  #
  #   it 'renders index view' do
  #     expect(response).to render_template :index
  #   end
  # end

  describe 'GET #new' do
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

      it 'redirects to index view' do
        post :create, params: { question_id: question, answer: attributes_for(:answer) }
        expect(response).to redirect_to(question_answers_path(assigns(:question)))
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
