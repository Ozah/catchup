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
    it { should have_link('Sign out') }
    it { should have_link("Edit profile", href: edit_user_path(user)) }
    it { should have_link("Add link", href: new_info_path) }

    describe "infos" do
      it { should have_content(info1.content) }
      it { should have_content(info2.content) }
      it { should have_link("delete", href: info_path(info1.id)) }
      it { should have_link("delete", href: info_path(info2.id)) }
    end

    describe "profile page of another user" do
      let(:user2) { FactoryGirl.create(:user) }
      let!(:info3) { FactoryGirl.create(:info, user: user2, content: "Foo") }
      let!(:info4) { FactoryGirl.create(:info, user: user2, content: "Bar") }

      before do
        visit user_path(user2)
      end

      it { should have_selector('h1',    text: user2.name) }
      it { should have_link('Sign out') }
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


  describe "signup page" do
    before { visit signup_path }

    it { should have_selector('h1',    text: 'Sign up') }
  end

  describe "signup" do

    before { visit signup_path }

    let(:submit) { "Create my account" }

    describe "with invalid information" do
      it "should not create a user" do
        expect { click_button submit }.not_to change(User, :count)
      end

      describe "after submission" do
        before { click_button submit }

        it { should have_selector('h1', text: 'Sign up') }
        it { should have_content('error') }
      end
    end

    describe "with valid information" do
      before do
        fill_in "Name",                       with: "Example User"
        fill_in "Email",                      with: "user@example.com"
        fill_in "Password",                   with: "foobar"
        fill_in "user_password_confirmation", with: "foobar"
      end

      it "should create a user" do
        expect { click_button submit }.to change(User, :count).by(1)
      end

      describe "after saving the user" do
        before { click_button submit }
        let(:user) { User.find_by_email('user@example.com') }

        it { should have_selector('h1', text: user.name) }
        it { should have_selector('div#alert-success', text: 'Welcome') }
        it { should have_link('Sign out') }
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
      it { should have_link('change', href: 'http://gravatar.com/emails') }
    end

    describe "with invalid information" do
      let(:new_name)  { "" }
      let(:new_email) { "" }
      before do
        fill_in "Name",                  with: new_name
        fill_in "Email",                 with: new_email
        click_button "Save changes"
      end

      it { should have_content('error') }
    end

    describe "with valid information" do
      let(:new_name)  { "New Name" }
      let(:new_email) { "new@example.com" }
      before do
        fill_in "Name",                  with: new_name
        fill_in "Email",                 with: new_email
        click_button "Save changes"
      end

      it { should have_selector('h1', text: new_name) }
      it { should have_selector('div#alert-success') }
      it { should have_link('Sign out', href: signout_path) }
      specify { user.reload.name.should  == new_name }
      specify { user.reload.email.should == new_email }
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
    it { should have_link('Sign out', href: signout_path) }

  end

end