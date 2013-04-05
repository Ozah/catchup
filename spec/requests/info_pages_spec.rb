require 'spec_helper'

describe "InfoPages" do
  subject { page }

  let(:user) { FactoryGirl.create(:user) }
  before { sign_in user }

  describe "info creation" do
    before { visit new_info_path }

    describe "with invalid information" do

      it "should not create an info" do
        expect { click_button "Add" }.not_to change(Info, :count)
      end

      describe "error messages" do
        before { click_button "Add" }
        it { should have_content('error') }
      end
    end

    describe "with valid information" do

      before { fill_in 'Info', with: "www.google.com" }
      it "should create an info" do
        expect { click_button "Add" }.to change(Info, :count).by(1)
      end
    end
  end

  describe "info destruction" do
    before { FactoryGirl.create(:info, user: user) }

    describe "as correct user" do
      before { visit user_path(user) }

      it "should delete an info" do
        expect { click_link 'delete_info' }.to change(Info, :count).by(-1)
      end
    end

    describe "delete links" do
      let(:user2) { FactoryGirl.create(:user) }
      before do
        FactoryGirl.create(:info, user: user2)
        user.add_contact!(user2)
        visit user_path(user2)
      end

      it { should_not have_link('delete_info') }

    end
  end
end
