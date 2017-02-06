require_relative '../feature_helper'

feature "Comment answer", %{
  AS: a signed in user
  I WANT TO: comment an answer
  IN ORDER TO: make some minor notes
} do

  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question) }

  context "Commentable shared examples" do
    before do
      do_login(user)
      visit question_path(question)
      @region = page.find("#answer#{answer.id}")
      @commentable = answer
      @commentable_short_name = "a"
    end

    it_behaves_like "comment_commentable"
  end

  scenario "Guest can't comment" do
    visit question_path(question)
    expect(page).not_to have_link "Add comment"
  end
end
