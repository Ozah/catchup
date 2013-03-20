require 'spec_helper'

describe "Meeting Pages" do
  
  subject { page }

  describe "new catchup page" do
  	let(:user) { FactoryGirl.create(:user) }

  	before do
  		sign_in user
  		visit new_user_meeting_path(user)
  	end

  	it { should have_selector('h1', text: "Catch up") }
    it { should have_link("Refresh") }
  end
end
