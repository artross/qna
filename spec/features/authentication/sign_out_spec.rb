require 'rails_helper'

feature "Sign out", %{
  AS: a signed in user
  I WANT TO: sign out
  IN ORDER TO: deny an access to the site for others
} do

  given(:user) { create(:user) }

  scenario "Signed in user signs out" do
    visit root_path
    click_on "Sign in"

    fill_in "Email", with: user.email
    fill_in "Password", with: user.password
    click_on "Log in"

    visit root_path
    click_on "Sign out"

    expect(current_path).to eq root_path
    expect(page).to have_content("Signed out successfully.")
  end

  scenario "Guest can't sign out" do
    visit root_path
    expect(page).not_to have_content("Sign out")
  end
end
