require_relative '../feature_helper'

feature "New answer", %{
  AS: a signed in user
  I WANT TO: create a new answer to a specific question
  IN ORDER TO: help the author of this question
} do

  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given(:answer) { attributes_for(:answer) }

  scenario "User creates a new answer", js: true do
    do_login(user)

    visit question_path(question)
    fill_in "Your answer", with: answer[:body]
    click_on "Add answer"

    expect(current_path).to eq question_path(question)
    expect(page).to have_content "Answers: 1"
    within('.answers') do
      expect(page).to have_content answer[:body]
      expect(page).to have_content "Author: #{user.email}"
    end
    expect(page).to have_content "Answer successfully added"
  end

  scenario "User can't create empty answer", js: true do
    do_login(user)

    visit question_path(question)
    click_on "Add answer"

    expect(page).to have_content "Unable to add such an answer"
    expect(page).to have_content "Body can't be blank"
  end

  scenario "Guest can't create a new answer" do
    visit question_path(question)
    fill_in "Your answer", with: answer[:body]
    click_on "Add answer"

    expect(current_path).to eq new_user_session_path
    expect(page).to have_content "You need to sign in or sign up before continuing."
  end
end
