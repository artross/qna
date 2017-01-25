require_relative '../feature_helper'

feature "Vote for question", %{
  AS: a signed in user
  I WANT TO: vote for question
  IN ORDER TO: express my opinion on its value
} do

  # user != question.author
  given!(:user) { create(:user) }
  given!(:question) { create(:question) }

  context "From index page" do
    scenario "Unable to vote" do
      # both for guests...
      visit questions_path
      expect(page).not_to have_link "vote-up-q#{question.id}"
      expect(page).not_to have_link "vote-down-q#{question.id}"

      # ...and authorized users
      do_login(user)
      visit questions_path
      expect(page).not_to have_link "vote-up-q#{question.id}"
      expect(page).not_to have_link "vote-down-q#{question.id}"
    end

    scenario "Correct rating is shown", js: true do
      do_login(user)
      within("#question#{question.id}") { expect(page).to have_text "Rating: 0" }

      visit question_path(question)
      click_on "vote-up-q#{question.id}"
      click_on "Back to all Questions"

      expect(current_path).to eq questions_path
      within("#question#{question.id}") { expect(page).to have_text "Rating: 1" }
    end
  end

  context "From show page" do
    context "Votable shared examples" do
      before do
        do_login(user)
        visit question_path(question)
        @region = page.find("#question#{question.id}")
        @votable = question
        @votable_short_name = "q"
      end

      it_behaves_like "vote_for_votable"
    end

    scenario "Can't vote for own question" do
      do_login(question.author)
      visit question_path(question)
      expect(page).not_to have_link "vote-up-q#{question.id}"
      expect(page).not_to have_link "vote-down-q#{question.id}"
    end  

    scenario "Guest can't vote" do
      visit question_path(question)
      expect(page).not_to have_link "vote-up-q#{question.id}"
      expect(page).not_to have_link "vote-down-q#{question.id}"
    end
  end

end
