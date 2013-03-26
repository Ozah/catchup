require 'spec_helper'

describe "Meeting Pages" do
  
  subject { page }

  describe "new catchup page" do
  	let(:user) { FactoryGirl.create(:user_at_home_now) }
    let(:time) { Time.now }
    let(:time_15) { Time.now - 15.minutes }
    
  	before do
      sign_in user
      user.location_time = time
  		visit new_user_meeting_path(user)
  	end

  	it { should have_selector('h1', text: "Catch up") }
    it { should have_link("Refresh") }
    it { should have_link("Manual") }
    it { should have_selector('#around_me_list') }
    it { find('#around_me_list').should_not have_selector('li') }
    
    describe "user2 at 3m, now", js: true do
      let(:user2) { FactoryGirl.create(:user_3m_away_now) }

      before do
        user2.location_time = time
        click_link "Refresh"
      end

      it { find('#around_me_list').should have_selector('li') }
      it { find('#around_me_list').find('li').should have_content(user2.name) }
      it { find('#around_me_list').find('li').should have_id("arround_me") }
      
      describe "inviting user2" do
        before do
          click_link user2.name
          click_link "Refresh"
        end
        it { find('#around_me_list').find('li').should_not have_id("arround_me") }
        it { find('#around_me_list').find('li').should have_id("invited") }
      end
    end

    describe "user2 at 30m, now", js: true do
      let(:user2) { FactoryGirl.create(:user_30m_away_now) }

      before do
        user2.location_time = time
        click_link "Refresh"
      end

      it { find('#around_me_list').should have_selector('li') }
      it { find('#around_me_list').find('li').should have_content(user2.name) }
    end

    describe "user2 at 100m, now", js: true do
      let(:user2) { FactoryGirl.create(:user_100m_away_now) }

      before do
        user2.location_time = time
        click_link "Refresh"
      end

      it { find('#around_me_list').should_not have_selector('li') }
    end

    describe "user2 at 3m, 15 minutes ago", js: true do
      let(:user2) { FactoryGirl.create(:user_3m_away_15m_ago) }

      before do
        user2.location_time = time_15
        click_link "Refresh"
      end

      it { find('#around_me_list').should_not have_selector('li') }
    end

    

  end
end
