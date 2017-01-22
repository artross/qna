class Answer < ApplicationRecord
  include Authorable
  include Attachable
  include Votable

  belongs_to :question

  validates :body, :question_id, presence: true

  def pick_as_best
    question = self.question
    Answer.transaction do
      question.answers.update_all(best_answer: false)
      self.update!(best_answer: true)
    end
  end
end
