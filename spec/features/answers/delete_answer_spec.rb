require_relative '../feature_helper'

feature "Delete answer", %{
  AS: a signed in user
  I WANT TO: delete my answer
  IN ORDER TO: remove pointless information
} do

  given!(:users) { create_pair(:user) }
  given!(:question) { create(:question, author: users[0]) }
  given!(:answer) { create(:answer, question: question, author: users[1]) }

  scenario "Author deletes his answer", js: true do
    do_login(users[1])
    visit question_path(question)
    click_on "del_a#{answer.id}"

    expect(current_path).to eq question_path(question)
    expect(page).to have_content "Answers: 0"
    within('.answers') { expect(page).not_to have_content(answer.body) }
    expect(page).to have_content "Answer successfully removed."
  end

  scenario "Non-author can't delete another's answer" do
    do_login(users[0])
    visit question_path(question)

    expect(page).not_to have_link("del_a#{answer.id}")
  end

  scenario "Guest can't delete an answer" do
    visit question_path(question)

    expect(page).not_to have_link("del_a#{answer.id}")
  end
end
