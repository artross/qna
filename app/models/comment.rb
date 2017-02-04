class Comment < ApplicationRecord
  include Authorable

  belongs_to :commentable, polymorphic: true, required: false
  validates :body, presence: true
end
