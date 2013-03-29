require 'spec_helper'

describe "User pages" do

  subject { page }

  describe "profile page" do
    let(:user) { FactoryGirl.create(:user) }
    let!(:info1) { FactoryGirl.create(:info, user: user, content: "Foo") }
    let!(:info2) { FactoryGirl.create(:info, user: user, content: "Bar") }

    before do
      sign_in user
      visit user_path(user)
    end

    it { should have_selector('h1',    text: user.name) }
    it { should have_link("Edit profile", href: edit_user_path(user)) }
    it { should have_link("Add link", href: new_info_path) }

    describe "footer navbar" do
      it { should have_link("Profile", href: user_path(user)) }
      it { should have_link("Contacts", href: contacts_path) }
      it { should have_link("Catchup", href: new_user_meeting_path(user)) }
      it { should have_link("History", href: user_show_list_path(user)) }
      it { should have_link("Info", href: help_path) }
    end

    describe "infos" do
      it { should have_content(info1.content) }
      it { should have_content(info2.content) }
      it { should have_link("delete", href: info_path(info1.id)) }
      it { should have_link("delete", href: info_path(info2.id)) }
    end

    describe "profile page of a user not in contacts" do
      let(:user2) { FactoryGirl.create(:user) }
      let!(:info3) { FactoryGirl.create(:info, user: user2, content: "Foo") }
      let!(:info4) { FactoryGirl.create(:info, user: user2, content: "Bar") }

      before { get user_path(user2) }
      specify { response.should redirect_to(root_path) }

      describe "profile page of a user in contacts" do
        before do
          user.add_contact!(user2)
          visit user_path(user2)
        end
        it { should have_selector('h1',    text: user2.name) }
        it { should_not have_link("Edit profile") }
        it { should_not have_link("Add link") }

        describe "infos" do
          it { should have_content(info3.content) }
          it { should have_content(info4.content) }
          it { should_not have_link("delete", href: info_path(info1.id)) }
          it { should_not have_link("delete", href: info_path(info2.id)) }
        end

      end

    end

  end


  describe "signup" do

    before { visit signup_path }

    it { should have_selector('h1', text: 'Sign up') }

    let(:submit) { "Create my account" }

    describe "with blank fields" do
      it "should not create a user" do
        expect { click_button submit }.not_to change(User, :count)
      end

      describe "after submission" do
        before { click_button submit }

        it { should have_selector('h1', text: 'Sign up') }
        it { should have_content('error') }
      end
    end

    describe "with valid name and email" do
      before do
        fill_in "new_user_name",  with: "Example User"
        fill_in "new_user_email", with: "user@example.com"
      end

      it "should create a user" do
        expect { click_button submit }.to change(User, :count).by(1)
      end

      describe "after saving the user" do
        before { click_button submit }
        let(:user) { User.find_by_email('user@example.com') }

        it { should have_selector('h1', text: user.name) }
        it { should have_selector('div#alert-success', text: 'Welcome') }
      end
    end

    describe "with name and no email" do
      before do
        fill_in "new_user_name",  with: "Example User"
      end

      it "should create a user" do
        expect { click_button submit }.to change(User, :count).by(1)
      end

      describe "after saving the user" do
        before { click_button submit }

        it { should have_selector('h1', text: "Example User") }
        it { should have_selector('div#alert-success', text: 'Welcome') }
      end
    end
  end

  describe "edit" do
    let(:user) { FactoryGirl.create(:user) }
    before do
      sign_in user
      visit edit_user_path(user)
    end

    describe "page" do
      #it { should have_selector('h1',    text: "Update your profile") }
      it { should have_selector('h1', text: "Edit user") }
      it { should have_selector('h2', text: "Change password") }
      it { should have_link('change', href: 'http://gravatar.com/emails') }
      it { should have_link('Sign out', href: signout_path) }
    end

    describe "with invalid information" do
      let(:new_name)  { "" }
      let(:new_email) { "" }
      before do
        fill_in "edit_user_name",  with: new_name
        fill_in "edit_user_email", with: new_email
        click_button "Save changes"
      end

      it { should have_content('error') }
    end

    describe "with valid name and email" do
      let(:new_name)  { "New Name" }
      let(:new_email) { "new@example.com" }
      before do
        fill_in "edit_user_name",  with: new_name
        fill_in "edit_user_email", with: new_email
        click_button "Save changes"
      end

      it { should have_selector('h1', text: new_name) }
      it { should have_selector('div#alert-success') }
      specify { user.reload.name.should  == new_name }
      specify { user.reload.email.should == new_email }
    end

    describe "with valid psw and pswconf" do
      let(:new_psw)  { "blabla" }
      before do
        fill_in "edit_user_psw",  with: new_psw
        fill_in "edit_user_pswconf", with: new_psw
        click_button "Save changes"
      end
      it { should have_selector('div#alert-success') }
    end

    describe "with valid name email psw and pswconf" do
      let(:new_name)  { "New Name" }
      let(:new_email) { "new@example.com" }
      let(:new_psw)  { "blabla" }
      before do
        fill_in "edit_user_name",  with: new_name
        fill_in "edit_user_email", with: new_email
        fill_in "edit_user_psw",  with: new_psw
        fill_in "edit_user_pswconf", with: new_psw
        click_button "Save changes"
      end

      it { should have_selector('h1', text: new_name) }
      it { should have_selector('div#alert-success') }
      specify { user.reload.name.should  == new_name }
      specify { user.reload.email.should == new_email }
    end

    describe "with unmatching psw and pswconf" do
      let(:new_psw)  { "blabla" }
      let(:new_pswconf)  { "bla" }
      before do
        fill_in "edit_user_psw",  with: new_psw
        fill_in "edit_user_pswconf", with: new_pswconf
        click_button "Save changes"
      end
      it { should have_content('error') }
    end

    describe "with valid password and without email" do
      let(:new_psw)  { "blabla" }
      before do
        fill_in "edit_user_email", with: ""
        fill_in "edit_user_psw",  with: new_psw
        fill_in "edit_user_pswconf", with: new_psw
        click_button "Save changes"
      end
      it { should have_content('Email cannot be empty') }
    end

    describe "with short password" do
      let(:new_psw)  { "bla" }
      before do
        fill_in "edit_user_psw",  with: new_psw
        fill_in "edit_user_pswconf", with: new_psw
        click_button "Save changes"
      end
      it { should have_content('too short') }
    end

  end

  describe "contacts page" do
    let!(:user) { FactoryGirl.create(:user) }
    let!(:user2) { FactoryGirl.create(:user) }
    let!(:user3) { FactoryGirl.create(:user) }
    before do
      user.add_contact!(user2)
      user.add_contact!(user3)
      sign_in user
      visit contacts_path
    end

    it { should have_selector('h1', text: "Contacts") }
    it { should have_link(user2.name, href: user_path(user2)) }
    it { should have_link(user3.name, href: user_path(user3)) }

  end

  describe "navigation" do

    let(:user) { FactoryGirl.create(:user) }

    before do
      sign_in user
      visit user_path(user)
    end

    describe "to Catchup" do
      before { click_link "Catchup" }

      it { should have_selector('h1', text: "Catch up") }
      it { should have_link("Refresh") }
    end

  end

end