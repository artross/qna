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
      click_on "edit_q#{question.id}"

      within("#question#{question.id}") do
        fill_in "Title", with: "Edited title"
        fill_in "Body", with: "Edited body"
        click_on "Save"

        expect(page).to have_content("Edited title")
        expect(page).to have_content("Edited body")

        expect(page).not_to have_content(question.title)
        expect(page).not_to have_content(question.body)

        expect(page).not_to have_selector('textarea')
      end

      expect(page).to have_content "Question successfully updated"
    end

    scenario "Author can't make his question blank", js: true do
      do_login(users[0])
      click_on "edit_q#{question.id}"

      within("#question#{question.id}") do
        fill_in "Title", with: ''
        fill_in "Body", with: ''
        click_on "Save"

        expect(page).not_to have_link "edit_q#{question.id}"
        expect(page).to have_selector('textarea')

        expect(page).to have_content(question.title)
        expect(page).to have_content(question.body)
      end

      expect(page).to have_content "Unable to make such changes to the question"
      expect(page).to have_content "Title can't be blank"
      expect(page).to have_content "Body can't be blank"
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
      click_on "edit_q#{question.id}"

      within("#question#{question.id}") do
        fill_in "Title", with: "Edited title"
        fill_in "Body", with: "Edited body"
        click_on "Save"

        expect(page).to have_content("Edited title")
        expect(page).to have_content("Edited body")

        expect(page).not_to have_content(question.title)
        expect(page).not_to have_content(question.body)

        expect(page).not_to have_selector('textarea')
      end

      expect(page).to have_content "Question successfully updated"
    end

    scenario "Author can't make his question blank", js: true do
      do_login(users[0])
      click_on "q#{question.id}"
      click_on "edit_q#{question.id}"

      within("#question#{question.id}") do
        fill_in "Title", with: ''
        fill_in "Body", with: ''
        click_on "Save"

        expect(page).not_to have_link "edit_q#{question.id}"
        expect(page).to have_selector('textarea')

        expect(page).to have_content(question.title)
        expect(page).to have_content(question.body)
      end

      expect(page).to have_content "Unable to make such changes to the question"
      expect(page).to have_content "Title can't be blank"
      expect(page).to have_content "Body can't be blank"
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
