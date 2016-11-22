require_relative '../feature_helper'

feature "Delete answer", %{
  AS: a signed in user
  I WANT TO: delete my answer
  IN ORDER TO: remove pointless information
} do

  given!(:users) { create_pair(:user) }
  given!(:question) { create(:question, author: users[0]) }
  given!(:answer) { create(:answer, question: question, author: users[1]) }

  scenario "Author deletes his answer" do
    do_login(users[1])
    visit question_path(question)
    click_on "Delete answer"

    expect(current_path).to eq question_path(question)
    expect(page).not_to have_content(answer.body)
    expect(page).to have_content "Answer successfully removed."
  end

  scenario "Non-author can't delete another's answer" do
    do_login(users[0])
    visit question_path(question)
    click_on "Delete answer"

    expect(page).to have_content(answer.body)
    expect(page).to have_content "Unable to delete another's answer!"
  end

  scenario "Guest can't delete an answer" do
    visit question_path(question)
    click_on "Delete answer"

    expect(page).to have_content "You need to sign in or sign up before continuing."
  end
end
