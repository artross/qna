require_relative '../feature_helper'

feature 'Edit question', %{
  AS: a signed in user
  I WANT TO: edit my own question
  IN ORDER TO: make it more clear and correct mistakes
} do

  given!(:users) { create_pair(:user) }
  given!(:question) { create(:question, author: users[0]) }

  context "From index page" do
    scenario "Author edits his question", remote: true do
      do_login(users[0])
      visit questions_path

      edit_question_and_check_valid(question, "#question#{question.id}", { title: "#{question.title} edited", body: "#{question.body} edited" })
      expect(current_path).to eq questions_path
    end

    scenario "Author can't make his question blank", remote: true do
      do_login(users[0])
      visit questions_path

      edit_question_and_check_blank(question, "#question#{question.id}")
      expect(current_path).to eq questions_path
    end

    scenario "Non-author can't edit another's question" do
      do_login(users[1])
      visit questions_path

      expect(page).not_to have_link("edit_q#{question.id}")
    end

    scenario "Guest can't edit questions" do
      visit questions_path

      expect(page).not_to have_link("edit_q#{question.id}")
    end
  end

  context "From show page" do
    scenario "Author edits his question", remote: true do
      do_login(users[0])
      visit question_path(question)

      edit_question_and_check_valid(question, '.question', { title: "#{question.title} edited", body: "#{question.body} edited"})
      expect(current_path).to eq question_path(question)
    end

    scenario "Author can't make his question blank", remote: true do
      do_login(users[0])
      visit question_path(question)

      edit_question_and_check_blank(question, '.question')
      expect(current_path).to eq question_path(question)
    end

    scenario "Non-author can't edit another's question" do
      do_login(users[1])
      visit question_path(question)

      expect(page).not_to have_link("edit_q#{question.id}")
    end

    scenario "Guest can't edit questions" do
      visit question_path(question)

      expect(page).not_to have_link("edit_q#{question.id}")
    end
  end
end
