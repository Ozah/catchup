class MeetingsController < ApplicationController

  #GET /users/:user_id/meetings/new - new_meetings_user_path - return an HTML form for creating a new meeting belonging to a specific user
  def new
    #@meeting = Meeting.new
  end

  def new_with_email

  end

  def new_with_contact
    @contacts = current_user.contacts
  end

  def create_with_email
    user = User.find_by_email(params[:email].downcase)
    if user
      # TODO
      flash[:success] = "New catchup!"
      redirect_to user_show_list_path(current_user)
    else
      flash.now[:error] = "This user doesn't exist"
      render 'new_with_email'
    end
  end

  def create
    print ("id=#{params[:user_id]} long=#{params[:long]} lat=#{params[:lat]}")
    redirect_to new_user_meeting_path(current_user)
  end

  def show_list
    #really ugly but works...
    @user_list = []
    if current_user.meetings.any?
      current_user.meetings.each do |meeting|
        @user_list += meeting.users.where("user_id != ?", current_user.id)
      end
    end

  end

  def show_map
    markers = []
    current_user.meetings.each do |meeting|
      markers << {lat: meeting.latitude, lng: meeting.longitude, description: "woohoo"}
    end
    gon.markers = markers
  end

end
