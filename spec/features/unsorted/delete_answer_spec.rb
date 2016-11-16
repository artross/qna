require 'rails_helper'

feature "Delete answer", %{
  AS: a signed in user
  I WANT TO: delete my answer
  IN ORDER TO: remove pointless information
} do
  scenario "Author deletes his answer"
  scenario "Non-author can't delete another's answer"
  scenario "Guest can't delete an answer"
end
