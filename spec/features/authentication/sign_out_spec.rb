require 'rails_helper'

feature "Sign out", %{
  AS: a signed in user
  I WANT TO: sign out
  IN ORDER TO: deny an access to the site for others
} do
  scenario "Signed in user signs out"
  scenario "Non-signed in user can't sign out"
end
