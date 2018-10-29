require 'rails_helper'

RSpec.feature "Userlogins", type: :feature do
  scenario "Admin User Sign In" do
    visit "/sessions/new"

    fill_in "User name", :with => "admin"
    fill_in "Password", :with => "secret1"
    click_button "Sign In"

    expect(page).to have_text("My Articles")
  end

  scenario "Google User Sign In" do
    visit "/auth/google_oauth2"
    expect(page).to have_text("My Articles")
  end





end
