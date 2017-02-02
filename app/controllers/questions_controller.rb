class QuestionsController < ApplicationController
  include AttachmentsParams

  before_action :authenticate_user!, except: [:index, :show]
  before_action :find_question, only: [:show, :update, :destroy]
  after_action :broadcast_question, only: [:create]

  def index
    @questions = Question.all
  end

  def show
    # nothing
  end

  def new
    @question = current_user.questions.new
  end

  def create
    @question = current_user.questions.create(question_params)

    if @question.persisted?
      flash[:notice] = "Question successfully created."
      redirect_to questions_path
    else
      flash.now[:alert] = "Unable to add such a question!"
      render :new
    end
  end

  def update
    if @question.author_id == current_user.id
      if @question.update(question_params)
        flash[:notice] = "Question successfully updated."
      else
        flash.now[:alert] = "Unable to make such changes to the question!"
      end

    else
      flash.now[:alert] = "Unable to edit another's question!"
      render :show
    end
  end

  def destroy
    if @question.author_id == current_user.id
      if @question.destroy
        flash[:notice] = "Question successfully removed."
        redirect_to questions_path
      else
        flash.now[:alert] = "Something went wrong..."
        render :show
      end
    else
      flash.now[:alert] = "Unable to delete another's question!"
      render :show
    end
  end

  private

  def find_question
    @question = Question.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body).tap do |filtered|
      extract_attachments_params!(params[:question], filtered)
    end
  end

  def broadcast_question
    return if @question.errors.any?
    ActionCable.server.broadcast 'questions', { question: @question, action: 'broadcast' }
  end
end
