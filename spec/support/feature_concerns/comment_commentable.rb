require 'rails_helper'

shared_examples_for 'comment_commentable' do
  scenario "User adds a comment", js: true do
    within(@region) do
      click_on "Add comment"
      expect(page).to have_content "Your comment"       # form appeared
      expect(page).not_to have_link "Add comment"

      fill_in "Your comment", with: "New comment"
      click_on "Submit"

      expect(page).not_to have_content "Your comment"   # form became hidden
      expect(page).to have_link "Add comment"

      expect(page).to have_content "New comment"
    end
    expect(page).to have_content "Comment successfully added"
  end

  scenario "User can't add blank comment", js: true do
    within(@region) do
      click_on "Add comment"
      click_on "Submit"

      expect(page).to have_content "Your comment"       # form is still there
      expect(page).not_to have_link "Add comment"       # link is still hidden
    end
    expect(page).to have_content "Unable to add such comment"
  end
end
