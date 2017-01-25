class VotesController < ApplicationController
  before_action :authenticate_user!

  def create
    vp = vote_params
    @votable = vp[:votable_type].constantize.find(vp[:votable_id])

    if @votable.author.id != current_user.id
      new_rating = @votable.rating + vp[:value].to_i
      Vote.transaction do
        @vote = @votable.votes.create!(vote_params.merge(author: current_user))
        @votable.update!(rating: new_rating)
      end

      respond_to do |format|
        format.json do
          if @vote.persisted?
            render json: @votable.attributes.merge({
              votes: @votable.votes.count,
              region: "#{@votable.class.name.underscore}#{@votable.id}",
              action: "vote",
              vote_value: vp[:value].to_i,
              vote_id: @vote.id
            })
          else
            render json: @vote.errors.full_messages, status: :unprocessable_entity
          end
        end
      end
    else
      respond_to do |format|
        format.json { render json: "Can't vote for your own piece", status: :forbidden }
      end
    end
  end

  def destroy
    vp = vote_params
    @votable = vp[:votable_type].constantize.find(vp[:votable_id])

    if @votable.author.id != current_user.id && params[:id].to_i > 0
      @vote = Vote.find(params[:id])
      new_rating = @votable.rating - @vote.value
      Vote.transaction do
        @vote.destroy!
        @votable.update!(rating: new_rating)
      end

      respond_to do |format|
        format.json do
          if @vote.persisted? # which means error
            render json: @vote.errors.full_messages, status: :unprocessable_entity
          else
            render json: @votable.attributes.merge({
              votes: @votable.votes.count,
              region: "#{@votable.class.name.underscore}#{@votable.id}",
              action: "unvote"
            })
          end
        end
      end
    else
      respond_to do |format|
        format.json { render json: "Forbidden", status: :forbidden }
      end
    end
  end

  private

  def vote_params
    params.require(:vote).permit(:votable_id, :votable_type, :value)
  end

end
