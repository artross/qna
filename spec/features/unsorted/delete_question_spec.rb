require 'rails_helper'

feature "Delete question", %{
  AS: a signed in user
  I WANT TO: delete my question
  IN ORDER TO: remove something nobody could benefit from
} do

  given(:users) { create_list(:user, 2) }
  given(:question) { create(:question, author: users[0]) }

  scenario "Author deletes his question" do
    do_login(users[0])

    visit question_path(question)
    click_on "Delete question"

    expect(current_path).to eq questions_path
    expect(page).not_to have_content question.title
    expect(page).not_to have_content question.body
  end

  scenario "Non-author can't delete another's question" do
    do_login(users[1])

    visit question_path(question)
    expect(page).not_to have_content "Delete question"
  end

  scenario "Guest can't delete a question" do
    visit question_path(question)
    expect(page).not_to have_content "Delete question"
  end
end
