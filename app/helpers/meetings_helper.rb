module MeetingsHelper

	def update_old_list
    @old_invited = []
    @old_invited_by = []
    # Not working???:
    # current_user.meetings.where("created_at < ?", Time.now - 10.minutes).each do |m|
    current_user.meetings.where(created_at: (Time.now - 100.years)..Time.now).each do |m|
      others = m.handshakes.where("user_id != ?", current_user.id)
      others.where(validated: false).each do |h|
        @old_invited << User.find_by_id(h.user_id)
      end

      m.handshakes.where(user_id: current_user.id, validated: false).each do |h|
        @old_invited_by << { users: m.users.where("user_id != ?", current_user.id), 
                             handshake_id: h.id }
      end
    end
  end

  def update_list
    # 0.125 miles = 201.168 meters
    nearbys = current_user.nearbys(0.125).where(location_time: (Time.now - 10.minutes)..Time.now)
    @around_me = nearbys
    @invited = []
    @invited_by = []
    @catching_up_with = []   

    nearbys.each do |p|
      p.meetings.where(created_at: (Time.now - 10.minutes)..Time.now).each do |m|
        if m.handshakes.all? { |h| h.validated == true }
          m.handshakes.where("user_id != ?", current_user.id).each do |h|
            @catching_up_with << { user: User.find_by_id(h.user_id), meeting: m }
          end
        end
      end
    end

    current_user.meetings.where(created_at: (Time.now - 10.minutes)..Time.now).each do |m|
      others = m.handshakes.where("user_id != ?", current_user.id)
      others.where(validated: false).each do |h|
        @invited << User.find_by_id(h.user_id)
      end

      m.handshakes.where(user_id: current_user.id, validated: false).each do |h|
        @invited_by << { users: m.users.where("user_id != ?", current_user.id), 
                             handshake_id: h.id }
      end
    end

    # for invited_by: maps the users and gets the first one if its a group meeting
    @around_me = nearbys - @catching_up_with.map{ |e| e[:user] } - 
                           @invited - 
                           @invited_by.map{ |e| e[:users][0] }
  end

end
