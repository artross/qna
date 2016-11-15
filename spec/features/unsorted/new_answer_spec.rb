require 'rails_helper'

feature "New answer", %q{
  AS: an authenticated user
  I WANT TO: create a new answer to a specific question
  IN ORDER TO: help the author of this question
} do

  scenario "Authenticated user creates a new answer"
  scenario "Guest can't create a new answer"

end
