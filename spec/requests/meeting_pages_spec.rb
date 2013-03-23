require 'spec_helper'

describe "Meeting Pages" do
  
  subject { page }

  describe "new catchup page" do
  	let(:user) { FactoryGirl.create(:user_at_home_now) }
    let(:time) { Time.now }
    let(:time_15) { Time.now - 15.minutes }
    
  	before do
      user.location_time = time
  		sign_in user
  		visit new_user_meeting_path(user)
  	end

  	it { should have_selector('h1', text: "Catch up") }
    it { should have_link("Refresh") }
    it { should have_link("Manual") }
    it { should have_selector('#around_me_list') }
    it { find('#around_me_list').should_not have_selector('li') }
    
    describe "user2 at 3m", js: true do
      let(:user2) { FactoryGirl.create(:user_3m_away_now) }

      before do
        user2.location_time = time
        visit new_user_meeting_path(user)
      end

      it { find('#around_me_list').should have_selector('li') }
      it { find('#around_me_list').find('li').should have_content(user2.name) }
    end

    describe "user2 at 30m", js: true do
      let(:user2) { FactoryGirl.create(:user_30m_away_now) }

      before do
        user2.location_time = time
        visit new_user_meeting_path(user)
      end

      it { find('#around_me_list').should have_selector('li') }
      it { find('#around_me_list').find('li').should have_content(user2.name) }
    end

    describe "user2 at 100m", js: true do
      let(:user2) { FactoryGirl.create(:user_100m_away_now) }

      before do
        user2.location_time = time
        visit new_user_meeting_path(user)
      end

      it { find('#around_me_list').should_not have_selector('li') }
    end

  end

end
