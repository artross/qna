class AddRatingToQuestionsAndAnswers < ActiveRecord::Migration[5.0]
  def change
    add_column :questions, :rating, :integer, null: false, default: 0
    add_column :answers, :rating, :integer, null: false, default: 0
  end
end
