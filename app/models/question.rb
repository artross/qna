class Question < ApplicationRecord
  has_many :answers, dependent: :destroy
  has_many :attachments, as: :attachable, dependent: :destroy
  belongs_to :author, class_name: "User"

  validates :title, :body, :author_id, presence: true

  accepts_nested_attributes_for :attachments, reject_if: :all_blank
end
