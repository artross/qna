require 'rails_helper'

feature "New question", %{
  AS: an authenticated user
  I WANT TO: create a new question
  IN ORDER TO: recieve answers
} do
  scenario "Authenticated user creates a new question"
  scenario "Guest can't create a new question"
end
