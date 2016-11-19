class AnswersController < ApplicationController
  before_action :authenticate_user!, except: :show
  before_action :find_question

  def create
    @answer = @question.answers.create(answer_params.merge(author: current_user))
    if @answer.persisted? then
      flash[:notice] = "Answer successfully added."
      redirect_to @question
    else
      flash.now[:alert] = "Unable to add such an answer!"
      render :'questions/show'
    end
  end

  def destroy
    @answer = Answer.find(params[:id])
    if @answer.author_id == current_user.id then
      if @answer.destroy then
        flash[:notice] = "Answer successfully removed."
        redirect_to question_path(@question)
      else
        flash.now[:alert] = "Something went wrong..."
        render :'questions/show'
      end
    else
      flash[:alert] = "Unable to delete another's answer!"
      render :'questions/show'
    end
  end

  private

  def find_question
    @question = Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end
end
