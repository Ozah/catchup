class MeetingsController < ApplicationController

  #GET /users/:user_id/meetings/new - new_meetings_user_path - return an HTML form for creating a new meeting belonging to a specific user
  def new
    #@meeting = Meeting.new
  end

  def new_with_email

  end

  def manual
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
    user_to_meet = User.find_by_id(params[:user_to_meet])
    current_user.add_contact!(user_to_meet) unless current_user.is_contact?(user_to_meet)    
    user_to_meet.add_contact!(current_user) unless user_to_meet.is_contact?(current_user)
      
    render :nothing => true
  end

  def confirm
    Handshake.find_by_id(params[:handshake_id]).update_attributes(validated: true)
    # redirect_to user_show_list_path(current_user)
    render :nothing => true
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

  def update_position
    current_user.update_attributes(longitude:     params[:longitude], 
                                   latitude:      params[:latitude],
                                   location_time: Time.now)
    # puts("BAM!!! longitude = #{params[:longitude]} latitude = #{params[:latitude]}")
    render :nothing => true
  end

  def update_page
    # puts("THIS IS MAD!!!!!!!!!!")
    nearbys = current_user.nearbys(0.03).where(location_time: (Time.now - 10.minutes)..Time.now)
    @around_me = nearbys
    @invited = []
    @invited_by = []
    @catching_up_with = []

    nearbys.each do |p|
      p.meetings.where(created_at: (Time.now - 10.minutes)..Time.now).each do |m|
        if m.handshakes.all? { |h| h.validated == true }
          m.handshakes.where("user_id != ?", current_user.id).each do |h|
            @catching_up_with << User.find_by_id(h.user_id)
          end
        end
      end
    end

    @around_me = nearbys - @catching_up_with

    current_user.meetings.each do |m|
      others = m.handshakes.where("user_id != ?", current_user.id)
      others.where(validated: false).each do |h|
        @invited << User.find_by_id(h.user_id)
      end

      m.handshakes.where(user_id: current_user.id, validated: false).each do |h|
        @invited_by << { users: m.users.where("user_id != ?", current_user.id), 
                             handshake_id: h.id }
      end
    end

    # current_user.meetings.each do |m|
    #   m.handshakes.each do |h|
    #     if (!h.validated)
    #       if (h.user_id != current_user.id)
    #         @invited << User.find_by_id(h.user_id)
    #       else #h.user_id == current_user.id
    #         @invited_by << { users: m.users.where("user_id != ?", current_user.id), 
    #                          handshake_id: h.id }
    #       end
    #     else #h.validated
    #       if (h.user_id != current_user.id) #TODO: add date < 10 min
    #         @catching_up_with << User.find_by_id(h.user_id)
    #       end
    #     end
    #   end
    # end
    respond_to do |format|
      format.js
    end
  end

  def update_page3
    # puts("THIS IS MAD!!!!!!!!!!")
    # the map is used to only send the id and name of the contacts (excludes the remember_token!!)
    @around_me = current_user.nearbys(0.03).map { |e| e.id_and_name }
    @pending = []
    @to_confirm = []
    current_user.meetings.each do |m|
      m.handshakes.each do |h|
        if (!h.validated)
          if (h.user_id != current_user.id)
            @pending << User.find_by_id(h.user_id).id_and_name
          else #h.user_id == current_user.id
            @to_confirm << { users: m.users.where("user_id != ?", current_user.id).map { |e| e.id_and_name }, 
                             handshake_id: h.id }
          end
        end
      end
    end
    render json: { around_me: @around_me, pending: @pending, to_confirm: @to_confirm, user_id: current_user.id }  
  end

  def update_page2
    @around_me = current_user.nearbys(0.03)
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

    # sign_in current_user
    respond_to do |format|
      format.js
    end
  end

end
