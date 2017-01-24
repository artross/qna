class VotesController < ApplicationController
  before_action :authenticate_user!

  def create
    vp = vote_params
    @votable = vp[:votable_type].constantize.find(vp[:votable_id])
    new_rating = @votable.rating + vp[:value].to_i

    Vote.transaction do
      @vote = @votable.votes.create!(vote_params.merge(author: current_user))
      @votable.update!(rating: new_rating)
    end

    binding.pry
    respond_to do |format|
      format.json { render json: @vote }
    end
  end

  private

  def vote_params
    params.require(:vote).permit(:votable_id, :votable_type, :value)
  end

end
