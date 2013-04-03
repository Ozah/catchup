# == Schema Information
#
# Table name: meetings
#
#  id         :integer          not null, primary key
#  latitude   :float
#  longitude  :float
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  venue_id   :integer
#

require 'spec_helper'

describe Meeting do
  let(:user1) { FactoryGirl.create(:user) }
  let(:user2) { FactoryGirl.create(:user) }
  let(:meeting) { FactoryGirl.create(:meeting) }
  
  subject { meeting }

  describe "meeting" do
    before do
      meeting.handshakes.create(user_id: user1.id)
      meeting.handshakes.create(user_id: user2.id)
    end

    it { should respond_to(:users) }
    it { should respond_to(:notes) }   
    it { should respond_to(:latitude) }
    it { should respond_to(:longitude) }
    it { should respond_to(:venue) }
    its(:users) { should include(user1) }
    its(:users) { should include(user2) }
    specify { user1.meetings.should include(meeting) }
    specify { user2.meetings.should include(meeting) }
  end

  describe "wrong user" do
    let(:user3) { FactoryGirl.create(:user) }

    its(:users) { should_not include(user3) }
  end

end
