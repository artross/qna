require_relative '../feature_helper'

feature "Best answer", %{
  AS: question's author
  I WANT TO: select the best answer
  IN ORDER TO: focus the other's attention on the best answer
} do

  given!(:users) { create_pair(:user) }
  given!(:question) { create(:question, author: users[0]) }
  given!(:answer) { create(:answer, question: question) }
  given(:second_answer) { create(:answer, question: question) }
  given(:best_answer) { create(:answer, question: question, best_answer: true) }

  context "Author" do
    scenario "picks the best answer for the first time", js: true do
      do_login(users[0])
      click_on "q#{question.id}"

      within("#answer#{answer.id}") do
        click_on "Pick as Best"
        expect(page).to have_content "Best answer!"
        expect(page).not_to have_button "Pick as Best"
      end
    end

    scenario "changes the best answer, which goes top", js: true do
      second_answer
      best_answer
      do_login(users[0])
      click_on "q#{question.id}"

      within("#answer#{second_answer.id}") { click_on "Pick as Best" }
      within("#answer#{best_answer.id}") do
        expect(page).not_to have_content "Best answer!"
        expect(page).to have_button "Pick as Best"
      end
      within('.answer:first-child') { expect(page).to have_content "Best answer!" }
    end

    scenario "can't mark an answer as 'the best' when it's already marked as 'the best'", js: true do
      best_answer
      do_login(users[0])
      click_on "q#{question.id}"

      within("#answer#{best_answer.id}") do
        expect(page).to have_content "Best answer!"
        expect(page).not_to have_button "Pick as Best"
      end
    end
  end

  scenario "User can't pick the best answer in another's question" do
    do_login(users[1])
    click_on "q#{question.id}"
    expect(page).not_to have_link "Pick as Best"
  end

  scenario "Guest can't pick the best answer" do
    visit question_path(question)
    expect(page).not_to have_link "Pick as Best"
  end

  scenario "Best answer is always shown first" do
    best_answer # was created after 'answer'...
    visit question_path(question)
    # ...but is shown before
    within('.answer:first-child') { expect(page).to have_content "Best answer!" }
  end
end
