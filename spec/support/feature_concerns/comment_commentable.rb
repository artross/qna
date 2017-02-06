require 'rails_helper'

shared_examples_for 'comment_commentable' do
  scenario "User adds a comment", js: true do
    within(@region) do
      click_on "Add comment"
      fill_in "Body", with: "New comment"
      click_on "Submit"

      expect(page).to have_content "New comment"
      expect(page).to have_content "Comment successfully added"
    end
  end
end
