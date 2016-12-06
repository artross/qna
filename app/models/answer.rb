class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :author, class_name: "User"
  has_many :attachments, as: :attach_box, dependent: :destroy

  validates :body, :question_id, :author_id, presence: true

  accepts_nested_attributes_for :attachments

  def pick_as_best
    question = self.question
    Answer.transaction do
      question.answers.update_all(best_answer: false)
      self.update!(best_answer: true)
    end
  end
end
