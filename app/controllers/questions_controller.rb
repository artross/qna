class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :find_question, only: [:update, :destroy]

  def index
    @questions = Question.all
  end

  def show
    @question = Question.find(params[:id])
  end

  def new
    @question = current_user.questions.new
  end

  def create
    @question = current_user.questions.create(question_params)
    if @question.persisted? then
      flash[:notice] = "Question successfully created."
      redirect_to questions_path
    else
      flash.now[:alert] = "Unable to add such a question!"
      render :new
    end
  end

  def update
    if @question.author_id == current_user.id then
      if @question.update(question_params) then
        flash.now[:notice] = "Question successfully updated"
      else
        flash.now[:alert] = "Unable to make such changes to the question!"
      end
    else
      flash.now[:alert] = "Unable to edit another's question!"
      render :show
    end
  end

  def destroy
    if @question.author_id == current_user.id then
      if @question.destroy then
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
    params.require(:question).permit(:title, :body)
  end
end
