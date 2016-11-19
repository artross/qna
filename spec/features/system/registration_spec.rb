require 'rails_helper'

feature "Registration", %{
  AS: a guest
  I WANT TO: register on the site
  IN ORDER TO: sign in
} do

  scenario "Non-registered user can register" do
    do_registration(build(:user))

    expect(current_path).to eq root_path
    expect(page).to have_content("Welcome! You have signed up successfully.")
  end

  scenario "Registered user can't register" do
    do_registration(create(:user))

    expect(current_path).to eq user_registration_path
    expect(page).to have_content("Email has already been taken")
  end
end
