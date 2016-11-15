class AnswersController < ApplicationController
  before_action :authenticate_user!, except: [:show]
  before_action :find_question

  # answers#index action is disabled due to changes in questions/show view

  # def index
  #   @answers = @question.answers
  # end

  def new
    @answer = @question.answers.new
  end

  def create
    @answer = @question.answers.create(answer_params)
    @answer.persisted? ? (redirect_to question_answers_path(@question)) : (render :new)
  end

  private

  def find_question
    @question = Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end
end
