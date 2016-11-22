require_relative '../feature_helper'

RSpec.feature "Sign in", %{
  AS: a registered user
  I WANT TO: sign in
  IN ORDER TO: ask and answer questions
} do

  scenario "Registered user signs in with correct email and password" do
    do_login(create(:user))
    expect(current_path).to eq root_path
    expect(page).to have_content("Signed in successfully.")
  end

  scenario "Not allowed to sign in with incorrect email or password" do
    do_login(build(:user, email: "wrong@test.com"))

    expect(current_path).to eq new_user_session_path
    expect(page).to have_content("Invalid Email or password.")
  end
end
