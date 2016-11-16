require 'rails_helper'

feature "New answer", %{
  AS: a signed in user
  I WANT TO: create a new answer to a specific question
  IN ORDER TO: help the author of this question
} do

  given(:question) { create(:question) }

  scenario "Authenticated user creates a new answer" do
    do_login(create(:user))

    visit question_path(question)
    click_on "Add answer"

    answer_body = "Anything you like to share"

    fill_in "Body", with: answer_body
    click_on "Post"

    expect(current_path).to eq question_path(question)
    expect(page).to have_content answer_body
  end

  scenario "Guest can't create a new answer" do
    visit question_path(question)
    click_on "Add answer"

    expect(current_path).to eq new_user_session_path
    expect(page).to have_content "You need to sign in or sign up before continuing."
  end
end
