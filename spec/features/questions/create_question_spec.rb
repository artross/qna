require 'rails_helper'

feature "New question", %{
  AS: a signed in user
  I WANT TO: create a new question
  IN ORDER TO: recieve answers
} do

  given(:question) { attributes_for(:question) }

  scenario "User creates a new question" do
    do_login(create(:user))

    visit questions_path
    click_on "Ask a new question"

    fill_in "Title", with: question[:title]
    fill_in "Body", with: question[:body]
    click_on "Ask Question"

    expect(page).to have_content question[:title]
    expect(page).to have_content question[:body]
    expect(page).to have_content "Question successfully created."
  end

  scenario "Guest can't create a new question" do
    visit questions_path
    click_on "Ask a new question"

    expect(current_path).to eq new_user_session_path
    expect(page).to have_content "You need to sign in or sign up before continuing."
  end
end
