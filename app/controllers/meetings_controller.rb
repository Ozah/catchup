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
    meeting = Meeting.create(latitude: current_user.latitude, 
                             longitude: current_user.longitude)
    meeting.handshakes.create(user_id: current_user.id, validated: true)
    meeting.handshakes.create(user_id: params[:user_to_meet])
    # TODO: add user_to_meet to contacts if new
    render 'new'
  end

  def confirm
    Handshake.find_by_id(params[:handshake_id]).update_attributes(validated: true)
    redirect_to user_show_list_path(current_user)
  end

  def show_list
    @user_list = []
    current_user.meetings.each do |m|
      m.handshakes.where("validated = true").where("user_id != ?", current_user.id).each do |h|
        @user_list << User.find_by_id(h.user_id)
      end
    end

    #to get the elements from most recent
    @user_list.reverse!
  end

  def show_map
    markers = []
    current_user.meetings.each do |meeting|
      markers << {lat: meeting.latitude, lng: meeting.longitude, description: "woohoo"}
    end
    gon.markers = markers
  end

  def update_page
    current_user.update_attributes(longitude:     params[:longitude], 
                                   latitude:      params[:latitude],
                                   location_time: Time.now)
    @arround_me = current_user.nearbys(0.03); 
    @pending = []
    @to_confirm = []
    current_user.meetings.each do |m|
      m.handshakes.each do |h|
        if (!h.validated)
          if (h.user_id != current_user.id)
            @pending << User.find_by_id(h.user_id)
          else #h.user_id == current_user.id
            @to_confirm << { users: m.users.where("user_id != ?", current_user.id), 
                             handshake_id: h.id }
          end
        end
      end
    end

    sign_in current_user
    respond_to do |format|
      format.js
    end
  end

end
