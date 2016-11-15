require 'rails_helper'

RSpec.feature "Sign in", %q{
  AS: a registered user
  I WANT TO: sign in
  IN ORDER TO: ask and answer questions
} do

  scenario "Registered user signs in with correct email and password"

  scenario "Registered user can't sign in with incorrect email"

  scenario "Registered user can't sign in with incorrect password"

  scenario "Non-registered user can't sign in"

end
