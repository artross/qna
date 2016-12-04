class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :author, class_name: "User"

  validates :body, :question_id, :author_id, presence: true

  def pick_as_best
    question = self.question
    question.answers.update_all(best_answer: false)
    self.update(best_answer: true)
  end
end
