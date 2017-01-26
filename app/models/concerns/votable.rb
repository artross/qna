module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, as: :votable, dependent: :destroy
    accepts_nested_attributes_for :votes, reject_if: :all_blank
  end

  def user_vote_value(user)
    vote = find_vote(user)&.value || 0
  end

  def user_vote_id(user)
    vote = find_vote(user)&.id || 0
  end

  def rating
    votes.sum(:value)
  end

  private

  def find_vote(user)
    votes.find_by(author: user)
  end
end
