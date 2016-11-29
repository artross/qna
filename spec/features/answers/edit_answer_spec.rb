require_relative '../feature_helper'

feature 'Edit answer', %{
  AS: a signed in user
  I WANT TO: edit my own answer
  IN ORDER TO: make it more clear and correct mistakes
} do

  given!(:users) { create_pair(:user) }
  given!(:question) { create(:question, author: users[0]) }
  given!(:answer) { create(:answer, question: question, author: users[1]) }

  scenario "Author edits his answer", js: true do
    do_login(users[1])
    click_on "q#{question.id}"
    click_on "edit_a#{answer.id}"

    within("#answer#{answer.id}") do
      fill_in "Your answer", with: "Edited"
      click_on "Save"

      expect(page).to have_content("Edited")
      expect(page).not_to have_content(answer.body)
      expect(page).not_to have_selector('textarea')
    end

    expect(current_path).to eq question_path(question)
    expect(page).to have_content "Answers: 1"
    expect(page).to have_content "Answer successfully updated"
  end

  scenario "Author can't make his answer blank", js: true do
    do_login(users[1])
    click_on "q#{question.id}"
    click_on "edit_a#{answer.id}"

    within("#answer#{answer.id}") do
      fill_in "Your answer", with: ''
      click_on "Save"

      expect(page).to have_content(answer.body)
      expect(page).not_to have_link "edit_a#{answer.id}"
      expect(page).to have_selector('textarea')
    end

    expect(page).to have_content "Unable to make such changes to an answer!"
    expect(page).to have_content "Body can't be blank"
  end

  scenario "Non-author can't edit another's answer" do
    do_login(users[0])
    visit question_path(question)

    expect(page).not_to have_link("edit_a#{answer.id}")
  end

  scenario "Guest can't edit answers" do
    visit question_path(question)

    expect(page).not_to have_link("edit_a#{answer.id}")
  end
end
