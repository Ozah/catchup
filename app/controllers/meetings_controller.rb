class MeetingsController < ApplicationController
  #GET /users/:user_id/meetings/new - new_meetings_user_path - returns an HTML form for creating a new meeting belonging to a specific user
  def new
    #@meeting = Meeting.new
    update_old_list
  end

  def new_with_email

  end

  def new_with_contact
    @contacts = current_user.contacts
  end

  def manual
  end

  def show
    @meeting = Meeting.find_by_id(params[:id])
    @other_users = @meeting.users.where("user_id != ?", current_user.id)  
  end

  def show_list
    @list = []
    current_user.meetings.order("created_at").each do |m|
      m.handshakes.where("validated = true").where("user_id != ?", current_user.id).each do |h|
        @list << { user: User.find_by_id(h.user_id), meeting: m }
      end
    end

    #to get the elements from most recent
    @list.reverse!
  end

  def show_map
    @markers = []
    current_user.meetings.each do |meeting|
      user = meeting.users.where("user_id != ?", current_user.id)[0]  
      @markers << { lat: meeting.latitude, lng: meeting.longitude, name: user.name }
    end
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

  #POST /user_meetings - user_meetings_path - creates a new meeting
  def create
    user_to_meet = User.find_by_id(params[:user_to_meet])
    first_to_invite = true
    current_user.meetings.where(created_at: (Time.now - 20.seconds)..Time.now).each do |m|
      # I have already been invited by the person I'm trying to invite
      if m.users.where(id: user_to_meet.id, validated: true) && m.users.where(id: current_user.id, validated: false)
        m.handshakes.where(user_id: current_user.id, validated: false).each do |h|
          h.update_attributes(validated: true)
          first_to_invite = false
        end
      end
    end
    if first_to_invite
      meeting = Meeting.create(latitude: current_user.latitude, 
                               longitude: current_user.longitude)
      meeting.handshakes.create(user_id: current_user.id, validated: true)
      meeting.handshakes.create(user_id: params[:user_to_meet])
    end
    
    # add the user_to_meet to contacts
    current_user.add_contact!(user_to_meet)   
    user_to_meet.add_contact!(current_user)
      
    render :nothing => true
  end

  def confirm
    Handshake.find_by_id(params[:handshake_id]).update_attributes(validated: true)
    # redirect_to user_show_list_path(current_user)
    # render :nothing => true
    render 'update_page'
  end

  def update_user_position
    current_user.update_position(params[:latitude], params[:longitude])
    # puts("BAM!!! longitude = #{params[:longitude]} latitude = #{params[:latitude]}")
    render :nothing => true
  end

  def update_location_list
    # puts("update_location_list: #{params}")
    @meeting = Meeting.find_by_id params[:meeting_id]
    get_foursquare_venues(@meeting.latitude, @meeting.longitude)
    respond_to do |format|
      format.js
    end
  end

  def update_venue
    @venue = Venue.find_by_foursquare_id params[:venue_id] 
    unless @venue
      fs_venue = get_foursquare_venue(params[:venue_id])
      @venue = Venue.create(foursquare_id: fs_venue.id, 
                           name: fs_venue.name,
                           location: fs_venue.location,
                           icon: fs_venue.icon,
                           latitude: fs_venue.location.lat,
                           longitude: fs_venue.location.lng)
    end
    @meeting = Meeting.find_by_id params[:meeting_id]
    @meeting.venue = @venue
    @meeting.update_attributes(latitude: @venue.location.lat, longitude: @venue.location.lng)
    @meeting.users.each do |user|
      user.venues << @venue unless user.venues.include?(@venue)
    end
    if @meeting.venue && !@meeting.venue.icon.blank?
      icon = @venue.icon
    else
      icon = nil
    end
    @marker = { lat: @venue.latitude, lng: @venue.longitude, name: @venue.name, icon: icon }
    puts("slkdjafghlaksjdhfbalkjsdbf!!!!!!!!!!!!!!!!!!!!!!!:  #{@marker}")
    respond_to do |format|
      format.js #{ render json: { marker: @marker } }
    end
  end

  def update_page
    update_list

    respond_to do |format|
      format.js 
    end
  end

  def get_many_markers
    @markers = []
    current_user.meetings.each do |meeting|
      user = meeting.users.where("user_id != ?", current_user.id)[0]  
      if meeting.venue && !meeting.venue.icon.blank?
        icon = meeting.venue.icon
      else
        icon = nil
      end
      @markers << { lat: meeting.latitude, lng: meeting.longitude, name: user.name, icon: icon }
    end 
    render json: { markers: @markers }
  end

  def get_single_marker
    meeting = Meeting.find_by_id(params[:meeting_id])
    @marker = { lat: meeting.latitude, lng: meeting.longitude, name: user.name }
    render json: { marker: @marker }
  end

end
