require_relative '../feature_helper'

feature "New answer", %{
  AS: a signed in user
  I WANT TO: create a new answer to a specific question
  IN ORDER TO: help the author of this question
} do

  given(:question) { create(:question) }
  given(:answer) { attributes_for(:answer) }

  scenario "User creates a new answer", js: true do
    do_login(create(:user))

    visit question_path(question)
    fill_in "Body", with: answer[:body]
    click_on "Add answer"

    expect(current_path).to eq question_path(question)
    within('.answers') { expect(page).to have_content answer[:body] }
  end

  scenario "Guest can't create a new answer" do
    visit question_path(question)
    fill_in "Body", with: answer[:body]
    click_on "Add answer"

    expect(current_path).to eq new_user_session_path
    expect(page).to have_content "You need to sign in or sign up before continuing."
  end
end
