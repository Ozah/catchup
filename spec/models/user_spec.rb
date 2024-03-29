# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  name            :string(255)
#  email           :string(255)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  password_digest :string(255)
#  remember_token  :string(255)
#  admin           :boolean          default(FALSE)
#  latitude        :float
#  longitude       :float
#  location_time   :datetime
#  address         :string(255)
#

require 'spec_helper'

describe User do
  before do
    @user = User.new(name: "Example User", email: "user@example.com",
                     password: "foobar", password_confirmation: "foobar")
  end

  subject { @user }

  it { should respond_to(:name) }
  it { should respond_to(:email) }
  it { should respond_to(:password_digest) }
  it { should respond_to(:password) }
  it { should respond_to(:password_confirmation) }
  it { should respond_to(:remember_token) }
  it { should respond_to(:admin) }
  it { should respond_to(:authenticate) }

  it { should respond_to(:infos) }

  it { should respond_to(:relationships) }
  it { should respond_to(:contacts) }
  it { should respond_to(:add_contact!) }
  it { should respond_to(:has_contact?) }

  it { should respond_to(:handshakes) }
  it { should respond_to(:meetings) }


  it { should be_valid }
  it { should_not be_admin }

  describe "admin attribute" do
    it  "should not be accessible" do
      expect do
        @user.update_attributes(:admin => true)
      end.to raise_error(ActiveModel::MassAssignmentSecurity::Error)
    end
  end

  describe "with admin attribute set to 'true'" do
    before do
      @user.save!
      @user.toggle!(:admin)
    end

    it { should be_admin }
  end

  describe "when name is not present" do
    before { @user.name = " " }
    it { should_not be_valid }
  end

  describe "when email is not present" do
    before { @user.email = " " }
    it { should be_valid }
  end

  describe "when name is too long" do
    before { @user.name = "a" * 51 }
    it { should_not be_valid }
  end

  describe "when email format is invalid" do
    it "should be invalid" do
      addresses = %w[user@foo,com user_at_foo.org example.user@foo.
                     foo@bar_baz.com foo@bar+baz.com]
      addresses.each do |invalid_address|
        @user.email = invalid_address
        @user.should_not be_valid
      end
    end
  end

  describe "when email format is valid" do
    it "should be valid" do
      addresses = %w[user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn]
      addresses.each do |valid_address|
        @user.email = valid_address
        @user.should be_valid
      end
    end
  end

  describe "when email address is already taken" do
    before do
      user_with_same_email = @user.dup
      user_with_same_email.email = @user.email.upcase
      user_with_same_email.save
    end

    it { should_not be_valid }
  end

  describe "email address with mixed case" do
    let(:mixed_case_email) { "Foo@ExAMPle.CoM" }

    it "should be saved as all lower-case" do
      @user.email = mixed_case_email
      @user.save
      @user.reload.email.should == mixed_case_email.downcase
    end
  end

  describe "when password is not present" do
    let(:user_with_blank_password) { User.new(name: "Example User2", email: "user2@example.com",
                     password: "", password_confirmation: "") }
      
    specify { user_with_blank_password.should_not be_valid }
  end

  describe "when password doesn't match confirmation" do
    before { @user.password_confirmation = "mismatch" }
    it { should_not be_valid }
  end

  describe "return value of authenticate method" do
    before { @user.save }
    let(:found_user) { User.find_by_email(@user.email) }

    describe "with valid password" do
      it { should == found_user.authenticate(@user.password) }
    end

    describe "with invalid password" do
      let(:user_for_invalid_password) { found_user.authenticate("invalid") }

      it { should_not == user_for_invalid_password }
      specify { user_for_invalid_password.should be_false }
    end
  end

  describe "remember token" do
    before do 
      @user.save 
      @user.create_remember_token
    end

    its(:remember_token) { should_not be_blank }

    it  "should not be accessible" do
      expect do
        @user.update_attributes(:remember_token => "123")
      end.to raise_error(ActiveModel::MassAssignmentSecurity::Error)
    end
  end

  describe "when remember token is already taken" do
    before do
      @user.remember_token = "123"
      user_with_same_remember_token = @user.dup
      user_with_same_remember_token.save
    end

    it { should_not be_valid }
  end

  describe "update without password" do
    before do
      @user.save
      @user.update_attributes(name: "new name")
      @user.save
    end

    it { should be_valid }
  end

  describe "infos associations" do
    before { @user.save }
    let!(:info) do
      FactoryGirl.create(:info, user: @user)
    end

    # TODO: test the order

    it "should destroy associated microposts" do
      infos = @user.infos.dup
      @user.destroy
      infos.should_not be_empty
      infos.each do |info|
        Info.find_by_id(info.id).should be_nil
      end
    end
  end

  describe "contacts" do
    describe "add contact" do
      let!(:other_user) { FactoryGirl.create(:user) }
      before do
        @user.save
        @user.add_contact!(other_user)
      end

      it { should be_has_contact(other_user)}
      its(:contacts) { should include(other_user)}
      specify { @user.contacts.length.should equal(1) }
    end

    describe "add contact twice" do
      let!(:other_user) { FactoryGirl.create(:user) }
      before do
        @user.save
        @user.add_contact!(other_user)
        @user.add_contact!(other_user)
      end
      specify { @user.contacts.length.should equal(1) }
    end

  end

  describe "meetings associations" do
    let!(:meeting) { FactoryGirl.create(:meeting) }
    before do
      @user.save
      meeting.handshakes.create!(user_id: @user.id)
    end

    its(:meetings) { should include(meeting) }
  end

  describe "users of the same meeting" do
    let!(:meeting) { FactoryGirl.create(:meeting) }
    let!(:user2) { FactoryGirl.create(:user) }
    before do
      @user.save
      meeting.handshakes.create!(user_id: @user.id)
      meeting.handshakes.create!(user_id: user2.id)
    end

    specify { @user.meetings[0].users.should include(user2) }
  end
end
