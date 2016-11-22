require_relative '../feature_helper'

feature "Show questions", %{
  AS: any visitor
  I WANT TO: see questions and answers
  IN ORDER TO: obtain useful information
} do

  given!(:questions) { create_pair(:question) }
  given!(:question) { create(:question_with_answers) }

  scenario "Any visitor can see a list of questions" do
    visit questions_path

    expect(current_path).to eq questions_path
    questions.each do |q|
      expect(page).to have_content(q.title)
      expect(page).to have_content(q.body)
    end
  end

  scenario "Any visitor can see particular question with all its answers" do
    visit question_path(question)

    expect(current_path).to eq question_path(question)
    expect(page).to have_content(question.title)
    expect(page).to have_content(question.body)

    question.answers.each do |a|
      expect(page).to have_content(a.body)
    end
  end
end
