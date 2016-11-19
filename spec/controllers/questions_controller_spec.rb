require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  describe 'GET #index' do
    let(:questions) { create_pair(:question) }
    before { get :index }

    it 'assigns an array' do
      expect(assigns(:questions)).to match_array(questions)
    end

    it 'renders index view' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    let(:question) { create(:question) }
    before { get :show, params: { id: question } }

    it 'assings question from params' do
      expect(assigns(:question)).to eq(question)
    end

    it 'renders show view' do
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do
    log_user_in
    before { get :new }

    it 'creates a new Question' do
      expect(assigns(:question)).to be_a_new(Question)
    end

    it 'renders new view' do
      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do
    log_user_in
    context 'with valid question' do
      it 'persists a question with its assosiated author' do
        expect do
          post :create, params: { author_id: @user, question: attributes_for(:question) }
        end.to change(@user.questions, :count).by(1)
      end

      it 'redirects to show view' do
        post :create, params: { question: attributes_for(:question) }
        expect(response).to redirect_to question_path(assigns(:question))
      end
    end

    context 'invalid question' do
      it "doesn't persist a question" do
        expect do
          post :create, params: { author_id: @user, question: attributes_for(:invalid_question) }
        end.not_to change(Question, :count)
      end

      it 're-renders new view' do
        post :create, params: { question: attributes_for(:invalid_question) }
        expect(response).to render_template :new
      end
    end
  end

  describe 'DELETE #destroy' do
    log_user_in

    context "with an author's question" do
      let(:question) { create(:question, author: @user) }

      it 'removes the question from DB' do
        question
        expect { delete :destroy, params: { id: question } }.to change(Question, :count).by(-1)
      end

      it 'redirects to index view' do
        delete :destroy, params: { id: question }
        expect(response).to redirect_to questions_path
      end
    end

    context "with another's question" do
      let(:question) { create(:question) }

      it "doesn't remove the question from DB" do
        question
        expect { delete :destroy, params: { id: question } }.not_to change(Question, :count)
      end

      it 're-renders show view' do
        delete :destroy, params: { id: question }
        expect(response).to render_template :show
      end
    end
  end
end
