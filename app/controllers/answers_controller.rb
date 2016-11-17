class AnswersController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :find_question

  def index
    redirect_to question_path(@question)
  end

  # answers#new doesn't exist anymore

  # def new
  #   @answer = @question.answers.new
  # end

  def create
    @answer = @question.answers.new(answer_params)
    @answer.author_id = current_user.id  # <- dunno how to do it better...
    @answer.save
    # @answer.persisted? ? (redirect_to question_path(@question)) : (render :new)
    redirect_to question_path(@question) # redirect anyway
  end

  def destroy
    @answer = Answer.find(params[:id])
    @answer.destroy if @answer.author == current_user
    redirect_to question_path(@question)
  end

  private

  def find_question
    @question = Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end
end
