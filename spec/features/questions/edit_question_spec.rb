require_relative '../feature_helper'

feature 'Edit question', %{
  AS: a signed in user
  I WANT TO: edit my own question
  IN ORDER TO: make it more clear and correct mistakes
} do

  given!(:users) { create_pair(:user) }
  given!(:question) { create(:question, author: users[0]) }

  context "From index page" do
    scenario "Author edits his question", js: true do
      do_login(users[0])

      edit_question_and_check_valid(question, { title: "Edited title", body: "Edited body" })
    end

    scenario "Author can't make his question blank", js: true do
      do_login(users[0])

      edit_question_and_check_blank(question)
    end

    scenario "Non-author can't edit another's question" do
      do_login(users[1])

      expect(page).not_to have_link("edit_q#{question.id}")
    end

    scenario "Guest can't edit questions" do
      visit questions_path

      expect(page).not_to have_link("edit_q#{question.id}")
    end
  end

  context "From show page" do
    scenario "Author edits his question", js: true do
      do_login(users[0])
      click_on "q#{question.id}"

      edit_question_and_check_valid(question, { title: "Edited title", body: "Edited body"})
    end

    scenario "Author can't make his question blank", js: true do
      do_login(users[0])
      click_on "q#{question.id}"

      edit_question_and_check_blank(question)
    end

    scenario "Non-author can't edit another's question" do
      do_login(users[1])
      click_on "q#{question.id}"

      expect(page).not_to have_link("edit_q#{question.id}")
    end

    scenario "Guest can't edit questions" do
      visit question_path(question)

      expect(page).not_to have_link("edit_q#{question.id}")
    end
  end
end
