class MeetingsController < ApplicationController

  #GET /users/:user_id/meetings/new - new_meetings_user_path - return an HTML form for creating a new meeting belonging to a specific user
  def new
    #@meeting = Meeting.new
  end

  def new_with_email

  end

  def new_with_contacts

  end

  def create

  end

  def show_list
    @user_list = nil
    current_user.meetings.each do |meeting|
      if @user_list == nil
        @user_list = meeting.users.where("user_id != ?", current_user.id)
      else
        @user_list << meeting.users.where("user_id != ?", current_user.id)
      end
    end
  end

  def show_map
    markers = []
    current_user.meetings.each do |meeting|
      markers << {lat: meeting.latitude, lng: meeting.longitude, description: "woohoo"}
    end
    @markers_json = markers.to_json
  end

end
