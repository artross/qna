require 'rails_helper'

feature "Guest functionality", %{
  AS: a guest
  I WANT TO: see questions and answers
  IN ORDER TO: obtain useful information
} do
  scenario "Guest can see a list of questions"
  scenario "Guest can see particular question with all its answers"
end
