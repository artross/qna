require_relative '../feature_helper'

feature "Vote for question", %{
  AS: a signed in user
  I WANT TO: vote for answer
  IN ORDER TO: express my opinion on its value
} do

  given(:user) { create(:user) }
  given(:question) { create(:question, author: user) }
  given!(:answer) { create(:answer, question: question) }

  context "Votable shared examples" do
    before do
      do_login(user)
      visit question_path(question)
      @region = page.find("#answer#{answer.id}")
      @votable = answer
      @votable_short_name = "a"
    end

    it_behaves_like "vote_for_votable"
  end

  scenario "Guest can't vote" do
    visit question_path(question)
    expect(page).not_to have_link "vote-up-a#{answer.id}"
    expect(page).not_to have_link "vote-down-a#{answer.id}"
  end
end
