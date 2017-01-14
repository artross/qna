class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :find_question
  before_action :find_answer, except: [:create]

  def create
    @answer = @question.answers.new(body: answer_params[:body], author: current_user)
    Answer.transaction do
      begin
        @answer.save!

        if answer_params[:attachments_attributes] &&
           answer_params[:attachments_attributes]["0"] &&
           answer_params[:attachments_attributes]["0"][:file] then

          answer_params[:attachments_attributes]["0"][:file].each do |file|
            @answer.attachments.create!(file: file)
          end
        end
        @transaction_successful = true
      rescue
        @transaction_successful = false
      end
    end

    if @transaction_successful then
      flash.now[:notice] = "Answer successfully added."
    else
      flash.now[:alert] = "Unable to add such an answer!"
    end
  end

  def update
    if @answer.author_id == current_user.id then
      Answer.transaction do
        begin
          @answer.update!(body: answer_params[:body])

          if answer_params[:attachments_attributes] &&
             answer_params[:attachments_attributes]["0"] &&
             answer_params[:attachments_attributes]["0"][:file] then

            answer_params[:attachments_attributes]["0"][:file].each do |file|
              @answer.attachments.create!(file: file)
            end
          end

          @transaction_successful = true
        rescue
          @transaction_successful = false
        end
      end

      if @transaction_successful then
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
    if @answer.author_id == current_user.id then
      if @answer.destroy then
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
    if @question.author_id == current_user.id then
      if @answer.pick_as_best then
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

  def find_question
    @question = Question.find(params[:question_id])
  end

  def find_answer
    @answer = Answer.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body, attachments_attributes: [file: []])
  end
end
