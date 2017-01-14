class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :find_question, only: [:show, :update, :destroy]

  def index
    @questions = Question.all
  end

  def show
    # this leads to strange "undefined method `email' for nil:NilClass" error
    #   on line 10 in 'answers/answer' partial,
    #   so a new Answer is now being built in question's show view
    # @answer = @question.answers.build
  end

  def new
    @question = current_user.questions.new
  end

  def create
    @question = current_user.questions.new(title: question_params[:title], body: question_params[:body])
    Question.transaction do
      begin
        @question.save!

        if question_params[:attachments_attributes] &&
           question_params[:attachments_attributes]["0"] &&
           question_params[:attachments_attributes]["0"][:file] then

          question_params[:attachments_attributes]["0"][:file].each do |file|
            @question.attachments.create!(file: file)
          end
        end
        @transaction_successful = true
      rescue
        # probably do nothing?
        @transaction_successful = false
      end
    end

    if @transaction_successful then
      flash[:notice] = "Question successfully created."
      redirect_to questions_path
    else
      flash.now[:alert] = "Unable to add such a question!"
      render :new
    end
  end

  def update
    if @question.author_id == current_user.id then
      Question.transaction do
        begin
          @question.update!(title: question_params[:title], body: question_params[:body])

          if question_params[:attachments_attributes] &&
             question_params[:attachments_attributes]["0"] &&
             question_params[:attachments_attributes]["0"][:file] then

            question_params[:attachments_attributes]["0"][:file].each do |file|
              @question.attachments.create!(file: file)
            end
          end
          @transaction_successful = true
        rescue
          @transaction_successful = false
        end
      end

      if @transaction_successful then
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
    params.require(:question).permit(:title, :body, attachments_attributes: [file: []])
  end
end
