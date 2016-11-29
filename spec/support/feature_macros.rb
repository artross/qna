module FeatureMacros
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

  # def wait_for_ajax
  #   Timeout.timeout(Capybara.default_max_wait_time) { loop until finished_all_ajax_requests? }
  # end
  #
  # def finished_all_ajax_requests?
  #   page.evaluate_script("$.active").zero?
  # end

  def edit_question_and_check_valid(question, new_attributes)
    click_on "edit_q#{question.id}"

    within("#question#{question.id}") do
      fill_in "Title", with: new_attributes[:title]
      fill_in "Body", with: new_attributes[:body]
      click_on "Save"

      expect(page).to have_content(new_attributes[:title])
      expect(page).to have_content(new_attributes[:body])

      expect(page).not_to have_content(question.title)
      expect(page).not_to have_content(question.body)

      expect(page).not_to have_selector('textarea')
    end

    expect(page).to have_content "Question successfully updated"
  end

  def edit_question_and_check_blank(question)
    click_on "edit_q#{question.id}"

    within("#question#{question.id}") do
      fill_in "Title", with: ''
      fill_in "Body", with: ''
      click_on "Save"

      expect(page).not_to have_link "edit_q#{question.id}"
      expect(page).to have_selector('textarea')

      expect(page).to have_content(question.title)
      expect(page).to have_content(question.body)
    end

    expect(page).to have_content "Unable to make such changes to the question"
    expect(page).to have_content "Title can't be blank"
    expect(page).to have_content "Body can't be blank"
  end

  def delete_question_and_check(question)
    click_on "Delete", id: "del_q#{question.id}"

    expect(page).not_to have_content question.title
    expect(page).not_to have_content question.body
    expect(page).to have_content "Question successfully removed."
  end
end
