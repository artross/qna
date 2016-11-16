class AnswersController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :find_question

  def index
    redirect_to question_path(@question)
  end

  def new
    @answer = @question.answers.new
  end

  def create
    @answer = @question.answers.create(answer_params)
    @answer.persisted? ? (redirect_to question_path(@question)) : (render :new)
  end

  private

  def find_question
    @question = Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end
end
