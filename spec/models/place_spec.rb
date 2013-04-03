# == Schema Information
#
# Table name: places
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  venue_id   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'spec_helper'

describe Place do
  let(:user) { FactoryGirl.create(:user) }
  let(:venue) { FactoryGirl.create(:venue) }
  let(:place) { user.places.build(venue_id: venue.id) }

  subject { place }

  it { should be_valid }

  describe "respond_to methods" do
    it { should respond_to(:user) }
    it { should respond_to(:venue) }
    its(:user) { should == user }
    its(:venue) { should == venue }
  end

  describe "when venue id is not present" do
    before { place.venue_id = nil }
    it { should_not be_valid }
  end

  describe "when user id is not present" do
    before { place.user_id = nil }
    it { should_not be_valid }
  end
end
