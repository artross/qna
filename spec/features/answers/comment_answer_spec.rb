require_relative '../feature_helper'

feature "Comment answer", %{
  AS: a signed in user
  I WANT TO: comment an answer
  IN ORDER TO: make some minor notes
} do

  context "Commentable shared examples" do
    it_behaves_like "comment_commentable"
  end
end
