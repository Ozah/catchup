class VenuesController < ApplicationController

	def find_nearbys
		@meeting = Meeting.find_by_id params[:meeting_id]
		get_foursquare_venues(@meeting.latitude, @meeting.longitude)
		
    respond_to do |format|
      format.js
    end
	end

	def update
	end

end
