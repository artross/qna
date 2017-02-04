require_relative '../feature_helper'

feature "Comment question", %{
  AS: a signed in user
  I WANT TO: comment a question
  IN ORDER TO: make some minor notes
} do

  context "Commentable shared examples" do
    it_behaves_like "comment_commentable"
  end
end
