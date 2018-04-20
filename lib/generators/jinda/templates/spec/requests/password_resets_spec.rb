require 'rails_helper'
RSpec.describe "PasswordResets", type: :request do
  before(:each) do 
    @user = User.create!(user: "test name", email: "email@yahoo.com", code: "12345")
  end	
  skip describe "GET /password_resets" do
    it "Forgetten password ? Button" do
      visit new_session_path
      click_link "Forgotten password?"
      fill_in "Email", :with => user.email
      click_button "Reset Password"
      expect(response).to redirect_to(root_path)
    end
  end
end
