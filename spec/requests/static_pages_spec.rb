require 'spec_helper'

describe "StaticPages" do
  subject { page }

  describe "Start page" do
    before { visit start_path }

    it { should have_content('CATCHUP') }
    it { should have_link('Try catchup as a guest') }
    it { should have_link('Sign up') }
    it { should have_link('Sign in') }

    it "should have the right links on the layout" do
      click_link "sign_up"
      page.should have_selector('h1',    text: 'Sign up')

      #click_link "Sign in"
      #page.should # fill in
      #click_link "Sign up as guest"
      #page.should # fill in
    end
  end
end
