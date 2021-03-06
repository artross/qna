class Question < ApplicationRecord
  include Authorable
  include Attachable
  include Votable

  has_many :answers, dependent: :destroy

  validates :title, :body, presence: true
end
