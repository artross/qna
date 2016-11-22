require_relative '../feature_helper'

feature "Sign out", %{
  AS: a signed in user
  I WANT TO: sign out
  IN ORDER TO: deny an access to the site for others
} do

  given(:user) { create(:user) }

  scenario "Signed in user signs out" do
    do_login(user)

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
