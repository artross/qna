require_relative '../feature_helper'

feature "New question", %{
  AS: a signed in user
  I WANT TO: create a new question
  IN ORDER TO: recieve answers
} do

  given(:user) { create(:user) }
  given(:question) { attributes_for(:question) }

  context "User creates a new question" do
    background do
      do_login(user)
      click_on "Ask a new question"

      fill_in "Title", with: question[:title]
      fill_in "Body", with: question[:body]
    end

    scenario "without any attachments" do
      click_on "Ask Question"

      expect(current_path).to eq questions_path
      within('.questions') do
        expect(page).to have_content question[:title]
        expect(page).to have_content question[:body]
        expect(page).to have_content "Author: #{user.email}"
        expect(page).to have_content "Answers: 0"
        expect(page).not_to have_content "Attached files:"
      end
      expect(page).to have_content "Question successfully created."
    end

    scenario "with one attachment" do
      attach_file "File", "#{Rails.root}/spec/files/a.txt"
      click_on "Ask Question"

      expect(current_path).to eq questions_path
      within('.questions') do
        expect(page).to have_content question[:title]
        expect(page).to have_content question[:body]
        expect(page).to have_content "Author: #{user.email}"
        expect(page).to have_content "Answers: 0"
        expect(page).to have_content "Attached files:"
        expect(page).to have_link "a.txt"
      end
      expect(page).to have_content "Question successfully created."
    end

    scenario "with several attachments"

  end

  scenario "User can't create empty question" do
    do_login(user)

    visit questions_path
    click_on "Ask a new question"
    # don't fill anything, leave all fields blank
    click_on "Ask Question"

    expect(page).to have_content "Unable to add such a question!"
  end

  scenario "Guest can't create a new question" do
    visit questions_path
    click_on "Ask a new question"

    expect(current_path).to eq new_user_session_path
    expect(page).to have_content "You need to sign in or sign up before continuing."
  end
end
