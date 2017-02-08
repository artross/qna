class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_commentable
  after_action :broadcast_comment, only: [:create]

  def create
    @comment = @commentable.comments.create(comment_params.merge(author: current_user))
    @region = "#{@commentable.class.name.underscore}#{@commentable.id}"
    if @comment.persisted?
      flash.now[:notice] = "Comment successfully added"
    else
      flash.now[:alert] = "Unable to add such comment!"
    end
  end

  private

  def find_commentable
    if params[:question_id]
      @commentable = Question.find(params[:question_id])
    elsif params[:answer_id]
      @commentable = Answer.find(params[:answer_id])
    else
      @commentable = nil
    end
  end

  def comment_params
    params.require(:comment).permit(:body)
  end

  def broadcast_comment
    return if @comment.errors.any?

    ActionCable.server.broadcast('comments', {
      region: @region,
      question: {
        id: @comment.question.id
      },
      comment: {
        id: @comment.id,
        body: @comment.body,
        authorId: @comment.author_id,
        authorEmail: @comment.author.email
      }
    })
  end
end
