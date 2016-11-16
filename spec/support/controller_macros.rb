module ControllerMacros
  def log_user_in
    before do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      @user = create(:user)
      sign_in @user
    end
  end
end
