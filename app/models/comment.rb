class Comment < ApplicationRecord
  include Authorable

  belongs_to :commentable, polymorphic: true, required: false
  validates :body, presence: true

  def question
    if commentable.class == Question
      commentable
    elsif commentable.class == Answer
      commentable.question
    else
      nil
    end      
  end
end
