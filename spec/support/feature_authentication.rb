module FeatureAuthentication
  def do_registration(user)
    visit root_path
    click_on "Register"

    fill_in "Email", with: user.email
    fill_in "Password", with: user.password
    fill_in "Password confirmation", with: user.password_confirmation
    click_on "Sign up"
  end

  def do_login(user)
    visit root_path
    click_on "Sign in"

    fill_in "Email", with: user.email
    fill_in "Password", with: user.password
    click_on "Log in"
  end
end
