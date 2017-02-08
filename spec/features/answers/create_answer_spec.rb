require_relative '../feature_helper'

feature "New answer", %{
  AS: a signed in user
  I WANT TO: create a new answer to a specific question
  IN ORDER TO: help the author of this question
} do

  given(:user) { create(:user) }
  given!(:question) { create(:question) }
  given(:answer) { attributes_for(:answer) }

  context "User creates a new answer" do
    background do
      do_login(user)
      click_on "q#{question.id}"
      fill_in "Your answer", with: answer[:body]
    end

    scenario "without any attachments", js: true do
      click_on "Add answer"

      expect(current_path).to eq question_path(question)
      expect(page).to have_content "Answers: 1"
      within('.answers') do
        expect(page).to have_content answer[:body]
        expect(page).to have_content "Author: #{user.email}"
        within('.attached-files') do
          expect(page).not_to have_content "Attached files:"
        end
      end
      expect(page).to have_content "Answer successfully added"
    end

    scenario "with one attachment", js: true do
      with_hidden_fields do
        attach_file "answer[attachments_attributes][0][file][]", "#{Rails.root}/spec/files/a.txt"
      end
      click_on "Add answer"

      expect(current_path).to eq question_path(question)
      expect(page).to have_content "Answers: 1"
      within('.answers') do
        expect(page).to have_content answer[:body]
        expect(page).to have_content "Author: #{user.email}"
        within('.attached-files') do
          expect(page).to have_content "Attached files:"
          expect(page).to have_link "a.txt"
        end
      end

      expect(page).to have_content "Answer successfully added"
    end

    scenario "with several attachments", js: true do
      with_hidden_fields do
        attach_file "answer[attachments_attributes][0][file][]", ["#{Rails.root}/spec/files/a.txt", "#{Rails.root}/spec/files/b.txt"]
      end
      click_on "Add answer"

      expect(current_path).to eq question_path(question)
      expect(page).to have_content "Answers: 1"
      within('.answers') do
        expect(page).to have_content answer[:body]
        expect(page).to have_content "Author: #{user.email}"
        within('.attached-files') do
          expect(page).to have_content "Attached files:"
          expect(page).to have_link "a.txt"
          expect(page).to have_link "b.txt"
        end
      end
      expect(page).to have_content "Answer successfully added"
    end
  end

  context "With multiple session" do
    scenario "New answer appears on another user's page with the same question", js: true do
      using_session 'user' do
        do_login user
        click_on "q#{question.id}"
      end

      using_session 'guest' do
        visit question_path(question)
      end

      using_session 'user' do
        fill_in "Your answer", with: answer[:body]
        with_hidden_fields do
          attach_file "answer[attachments_attributes][0][file][]", "#{Rails.root}/spec/files/a.txt"
        end
        click_on "Add answer"
      end

      using_session 'guest' do
        expect(page).to have_content "Answers: 1"
        within('.answers') do
          expect(page).to have_content answer[:body]
          expect(page).to have_content "Author: #{user.email}"
          within('.attached-files') do
            expect(page).to have_content "Attached files:"
            expect(page).to have_link "a.txt"
          end
        end
      end
    end

    scenario "New answer does not appear on another user's page with another question", js: true do
      second_question = create(:question)

      using_session 'user' do
        do_login user
        click_on "q#{question.id}"
      end

      using_session 'guest' do
        visit question_path(second_question)
      end

      using_session 'user' do
        fill_in "Your answer", with: answer[:body]
        click_on "Add answer"
      end

      using_session 'guest' do
        expect(page).to have_content "Answers: 0"
        within('.answers') do
          expect(page).not_to have_content answer[:body]
          expect(page).not_to have_content "Author: #{user.email}"
        end
      end
    end
  end

  scenario "User can't create empty answer", js: true do
    do_login(user)

    visit question_path(question)
    click_on "Add answer"

    expect(page).to have_content "Unable to add such an answer"
    expect(page).to have_content "Body can't be blank"
  end

  scenario "Guest can't create a new answer" do
    visit question_path(question)
    fill_in "Your answer", with: answer[:body]
    click_on "Add answer"

    expect(current_path).to eq new_user_session_path
    expect(page).to have_content "You need to sign in or sign up before continuing."
  end
end
