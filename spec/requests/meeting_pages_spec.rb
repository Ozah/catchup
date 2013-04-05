require 'spec_helper'

describe "Meeting Pages" do
  
  subject { page }

  describe "new catchup page", js: true do
  	let(:user) { FactoryGirl.create(:user_at_home_now) }
    let(:time) { Time.now }
    let(:time_15) { Time.now - 15.minutes }
    
  	before do
      sign_in user
      user.location_time = time
  		visit new_user_meeting_path(user)
  	end

  	it do
      should have_selector('h1', text: "Catch up") 
      should have_link("Refresh") 
      # should have_link("Manual") 
      should have_selector('#around_me_list') 
      should have_selector('#no_one_arround') 
      find('#around_me_list').should_not have_selector('li') 
    end
    
    describe "user2 at 3m, now" do
      let(:user2) { FactoryGirl.create(:user_3m_away_now) }

      before do
        user2.location_time = time
        # click_link "Refresh"
        # visit new_user_meeting_path(user)
      end

      it do
        should_not have_selector('#no_one_arround')
        find('#around_me_list').should have_selector('li') 
        find('#around_me_list').find('li').should have_content(user2.name) 
        find('#around_me_list').should have_selector("#arround_me") 
      end
      
      describe "inviting user2" do
        before do
          click_link user2.name
          page.driver.browser.switch_to.alert.accept
          # the render caused by clicking the confirm doesn't seem to be registered 
          # therefore I refresh the page manually
          click_link "Refresh" 
        end
        it do
          should_not have_selector('#no_one_arround') 
          find('#around_me_list').should_not have_selector("#arround_me") 
          find('#around_me_list').find('li').should have_content(user2.name) 
          find('#around_me_list').should have_selector("#invited") 
        end
      end

      describe "user2 invited me" do
        let(:meeting) { FactoryGirl.create(:meeting)}
        
        before do
          meeting.handshakes.create(user_id: user.id)
          meeting.handshakes.create(user_id: user2.id, validated: true)
          click_link "Refresh" 
        end
        it do
          should_not have_selector('#no_one_arround') 
          find('#around_me_list').should_not have_selector("#arround_me") 
          find('#around_me_list').find('li').should have_content(user2.name) 
          find('#around_me_list').should have_selector("#invited_by") 
        end

        describe "accepting user2's invite" do
          before do
            click_link user2.name
            page.driver.browser.switch_to.alert.accept
            # the render caused by clicking the confirm doesn't seem to be registered 
            # therefore I refresh the page manually
            click_link "Refresh" 
          end 
          it do
            should_not have_selector('#no_one_arround') 
            find('#around_me_list').should_not have_selector("#arround_me") 
            find('#around_me_list').should_not have_selector("#invited_by") 
            find('#around_me_list').find('li').should have_content(user2.name) 
            find('#around_me_list').should have_selector("#catching_up_with") 
          end
        end
      end
    end

    describe "user2 at 30m, now" do
      let(:user2) { FactoryGirl.create(:user_30m_away_now) }

      before do
        user2.location_time = time
        click_link "Refresh"
      end

      it do
        should_not have_selector('#no_one_arround') 
        find('#around_me_list').should have_selector('li') 
        find('#around_me_list').find('li').should have_content(user2.name) 
      end
    end

    describe "user2 far away, now" do
      let(:user2) { FactoryGirl.create(:user_250m_away_now) }

      before do
        user2.location_time = time
        click_link "Refresh"
      end

      it do 
        should have_selector('#no_one_arround') 
        find('#around_me_list').should_not have_selector('li') 
      end
    end

    describe "user2 at 3m, 15 minutes ago" do
      let(:user2) { FactoryGirl.create(:user_3m_away_15m_ago) }

      before do
        user2.location_time = time_15
        click_link "Refresh"
      end

      it do
        should have_selector('#no_one_arround') 
        find('#around_me_list').should_not have_selector('li') 
      end
    end
  end

  describe "edit page" do
    
  end

  describe "show page" do
    
  end
  
end
