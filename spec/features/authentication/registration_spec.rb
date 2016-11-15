require 'rails_helper'

feature "Registration", %{
  AS: a guest
  I WANT TO: register on the site
  IN ORDER TO: sign in
} do
  scenario "Non-registered user can register"
  scenario "Registered user can't register"
end
