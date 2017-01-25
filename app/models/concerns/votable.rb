module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, as: :votable, dependent: :destroy
    accepts_nested_attributes_for :votes, reject_if: :all_blank
  end

  def user_vote_value(user)
    vote = find_vote(user)
    vote ? vote.value : 0
  end

  def user_vote_id(user)
    vote = find_vote(user)
    vote ? vote.id : 0
  end

  private

  def find_vote(user)
    Vote.where(votable: self, author: user).take
  end
end
