require 'rails_helper'

feature "Delete question", %{
  AS: a signed in user
  I WANT TO: delete my question
  IN ORDER TO: remove something nobody could benefit from
} do
  scenario "Author deletes his question"
  scenario "Non-author can't delete another's question"
  scenario "Guest can't delete a question"
end
