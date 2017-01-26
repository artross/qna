class VotesController < ApplicationController
  before_action :authenticate_user!

  def create
    vp = vote_params
    @votable = vp[:votable_type].constantize.find(vp[:votable_id])

    if @votable.author.id != current_user.id
      @vote = @votable.votes.create(vote_params.merge(author: current_user))
      if @vote.persisted?
        render json: {
          rating: @votable.rating,
          votes: @votable.votes.count,
          region: "#{@votable.class.name.underscore}#{@votable.id}",
          action: "vote",
          vote_value: vp[:value].to_i,
          vote_id: @vote.id
        }
      else
        render json: @vote.errors.full_messages, status: :unprocessable_entity
      end
    else
      render json: "Can't vote for your own piece", status: :forbidden
    end
  end

  def destroy
    vp = vote_params
    @votable = vp[:votable_type].constantize.find(vp[:votable_id])

    if @votable.author.id != current_user.id && params[:id].to_i > 0
      if Vote.find(params[:id]).destroy
        render json: {
          rating: @votable.rating,
          votes: @votable.votes.count,
          region: "#{@votable.class.name.underscore}#{@votable.id}",
          action: "unvote"
        }
      else
        render json: @vote.errors.full_messages, status: :unprocessable_entity
      end
    else
      render json: "Forbidden", status: :forbidden
    end
  end

  private

  def vote_params
    params.require(:vote).permit(:votable_id, :votable_type, :value)
  end

end
