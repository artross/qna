require_relative '../feature_helper'

feature "Comment question", %{
  AS: a signed in user
  I WANT TO: comment a question
  IN ORDER TO: make some minor notes
} do

  given(:user) { create(:user) }
  given!(:question) { create(:question) }

  context "From index page" do
    scenario "Unable to comment" do
      # both for guests...
      visit questions_path
      expect(page).not_to have_link "Add comment"

      # ...and authorized users
      do_login(user)
      expect(page).not_to have_link "Add comment"
    end
  end

  context "From show page" do
    context "Commentable shared examples" do
      before do
        do_login(user)
        visit question_path(question)
        @region = page.find("#question#{question.id}")
        @commentable = question
        @commentable_short_name = "q"
      end

      it_behaves_like "comment_commentable"
    end

    scenario "Guest can't comment" do
      visit question_path(question)
      expect(page).not_to have_link "Add comment"
    end
  end
end
