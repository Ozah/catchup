# == Schema Information
#
# Table name: handshakes
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  meeting_id :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  validated  :boolean          default(FALSE)
#

require 'spec_helper'

describe Handshake do
  let(:user) { FactoryGirl.create(:user) }
  let(:meeting) { FactoryGirl.create(:meeting) }
  let(:handshake) { user.handshakes.build(meeting_id: meeting.id) }

  subject { handshake }

  it { should be_valid }

  describe "methods" do
    it { should respond_to(:user) }
    it { should respond_to(:meeting) }
    it { should respond_to(:validated) }
    its(:user) { should == user }
    its(:meeting) { should == meeting }
    its(:validated) { should == false }
  end

  describe "when user id is not present" do
    before { handshake.user_id = nil }
    it { should_not be_valid }
  end

  describe "when meeting id is not present" do
    before { handshake.meeting_id = nil }
    it { should_not be_valid }
  end
end
