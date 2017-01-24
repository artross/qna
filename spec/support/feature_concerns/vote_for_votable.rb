require 'rails_helper'

shared_examples_for "vote_for_votable" do
  scenario "votes up" do
    within(@region) do
      expect(page).to have_text "Rating: 0"
      click_on "vote-up-#{@votable_short_name}#{@votable.id}"

      expect(page).to have_text "Rating: 1"
      expect(page).not_to have_link "vote-up-#{@votable_short_name}#{@votable.id}"
      expect(page).not_to have_link "vote-down-#{@votable_short_name}#{@votable.id}"
    end
  end

  scenario "votes down" do
    within(@region) do
      expect(page).to have_text "Rating: 0"
      click_on "vote-down-#{@votable_short_name}#{@votable.id}"

      expect(page).to have_text "Rating: -1"
      expect(page).not_to have_link "vote-up-#{@votable_short_name}#{@votable.id}"
      expect(page).not_to have_link "vote-down-#{@votable_short_name}#{@votable.id}"
    end
  end
end
