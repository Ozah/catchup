# == Schema Information
#
# Table name: notes
#
#  id         :integer          not null, primary key
#  content    :string(255)
#  user_id    :integer
#  meeting_id :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'spec_helper'

describe Note do

  let(:meeting) { FactoryGirl.create(:meeting) }
  let(:user) { FactoryGirl.create(:user) }
  before do
  	meeting.handshakes.create(user_id: user.id)
  	@note = meeting.notes.build(user_id: user.id, content: "comment")
  end

  subject { @note }

  it { should respond_to(:content) }
  it { should respond_to(:meeting_id) }
  it { should respond_to(:user_id) }
  it { should respond_to(:meeting) }
  it { should respond_to(:user) }

  its(:user) { should == user }
  its(:meeting) { should == meeting }

  it { should be_valid }

  # describe "accessible attributes" do
  #   it "should not allow access to meeting_id" do
  #     expect do
  #       Note.new(meeting_id: meeting.id)
  #     end.to raise_error(ActiveModel::MassAssignmentSecurity::Error)
  #   end
  # end

  describe "when user_id is not present" do
    before { @note.user_id = nil }
    it { should_not be_valid }
  end

  describe "when meeting_id is not present" do
    before { @note.meeting_id = nil }
    it { should_not be_valid }
  end

  describe "with blank content" do
    before { @note.content = " " }
    it { should_not be_valid }
  end

  # describe "with content that is too long" do
  #   before { @note.content = "a" * 81 }
  #   it { should_not be_valid }
  # end
end
