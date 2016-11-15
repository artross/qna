class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]

  def index
    @questions = Question.all
  end

  def show
    @question = Question.find(params[:id])
  end

  def new
    @question = Question.new
  end

  def create
    @question = Question.create(question_params)
    @question.persisted? ? (redirect_to @question) : (render :new)
  end

  private

  def question_params
    params.require(:question).permit(:title, :body)
  end
end
