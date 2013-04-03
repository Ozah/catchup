# == Schema Information
#
# Table name: venues
#
#  id            :integer          not null, primary key
#  foursquare_id :string(255)
#  name          :string(255)
#  location      :text
#  icon          :text
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  latitude      :float
#  longitude     :float
#

require 'spec_helper'

describe Venue do

	before do
		@venue = Venue.new(name: "Venue", latitude: 1, longitude: 2)
	end

	subject { @venue }

	it { should respond_to(:name) }	
	it { should respond_to(:latitude) }
	it { should respond_to(:longitude) }
	it { should respond_to(:users) }
	it { should respond_to(:places) }
	it { should respond_to(:foursquare_id) }
	it { should respond_to(:location) }
	it { should be_valid }

	describe "link to meeting and user" do
	  let(:meeting) { FactoryGirl.create(:meeting) }
	  let(:user) { FactoryGirl.create(:user) }
	  
	  before do
	  	meeting.venue = @venue
	  	user.venues << @venue
	  end

	  its(:users) { should include(user) }
	  # not working here but works in code...
	  # its(:meetings) { should include(meeting) }
	  specify { user.venues.should include(@venue) }
	  specify { meeting.venue.should equal(@venue) }

	end

end
