class AnswersController < ApplicationController
  include AttachmentsParams

  before_action :authenticate_user!
  before_action :find_answer, except: [:create]
  before_action :assign_question, except: [:create]
  after_action :broadcast_answer, only: [:create]

  def create
    @question = Question.find(params[:question_id])
    @answer = @question.answers.create(answer_params.merge(author: current_user))

    if @answer.persisted?
      flash.now[:notice] = "Answer successfully added."
    else
      flash.now[:alert] = "Unable to add such an answer!"
    end
  end

  def update
    if @answer.author_id == current_user.id
      if @answer.update(answer_params)
        flash.now[:notice] = "Answer successfully updated"
      else
        flash.now[:alert] = "Unable to make such changes to an answer!"
      end

    else
      flash.now[:alert] = "Unable to edit another's answer!"
      render :'questions/show'
    end
  end

  def destroy
    if @answer.author_id == current_user.id
      if @answer.destroy
        flash.now[:notice] = "Answer successfully removed."
      else
        flash.now[:alert] = "Something went wrong..."
        render :'questions/show'
      end
    else
      flash.now[:alert] = "Unable to delete another's answer!"
      render :'questions/show'
    end
  end

  def best_answer
    if @question.author_id == current_user.id
      if @answer.pick_as_best
        flash.now[:notice] = "Best answer successfully set."
      else
        flash.now[:alert] = "Something went wrong..."
      end
    else
      flash.now[:alert] = "Unable to pick the best answer in another's question!"
      render :'questions/show'
    end
  end

  private

  def find_answer
    @answer = Answer.find(params[:id])
  end

  def assign_question
    @question = @answer.question
  end

  def answer_params
    params.require(:answer).permit(:body, comments_attributes: [:body]).tap do |filtered|
      extract_attachments_params!(params[:answer], filtered)
    end
  end

  def broadcast_answer
    return if @answer.errors.any?

    ActionCable.server.broadcast('answers', {
      question: {
        id: @question.id,
        answersCount: @question.answers.count,
        authorId: @question.author_id
      },
      answer: {
        id: @answer.id,
        body: @answer.body,
        bestAnswer: @answer.best_answer,
        authorId: @answer.author_id,
        authorEmail: @answer.author.email,
        attachments: @answer.attachments_array_for_broadcasting,
        bestAnswerPath: best_answer_answer_path(@answer)
      }
    })
  end
end
