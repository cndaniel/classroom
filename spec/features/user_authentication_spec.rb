require "rails_helper"


RSpec.feature "User authentication" do
  before{ create(:user, email:" user@example.com", password: "password")}
  scenario "existinig uer signs in" do


    visit "/users/sign_in"

    new_session_page.sign_in "user@example.com", "password"


    expect(page).to have_text "user@example.com"


  end

  scenario "user signs out" do
    visit "/users/sign_in"

    within(".new_user") do
      fill_in "Email", with:"user@example.com"
      fill_in "Password", with: "password"
    end

    click_button "Log in"
    click_link "Logout"

     expect(page).not_to have_text "user@example.com"
  end

  private
  def home_page
  PageObjects::Pages::Home.new
  end

  def new_session_page
    home.page.go
    navbar.sign_in
    #code
  end

  def navbar
    Pageobjects::Aplication::Navbar.new
    #code
  end
end
