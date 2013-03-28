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
    # 0.03 miles = 48.28032 meters
    nearbys = current_user.nearbys(0.03).where(location_time: (Time.now - 10.minutes)..Time.now)
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
  
	def get_foursquare_venues
    # client = Foursquare2::Client.new(client_id: 'F2VJIIH4XZWMXBMKT1QG55XNXTVZ3SRDP5USQC5IQ2POIANE', client_secret: 'MPURINUKRFOEDVGXLRBG23RBW3KNHA1IBN2PWQWQLBJPW5UO')
    # resp = client.search_venues(ll: '48.849117,2.4420522', intent: 'browse', radius: '100')
    # response = HTTParty.get('https://api.foursquare.com/v2/venues/search?&ll=48.849117,2.4420522&intent=browse&radius=100&client_id=F2VJIIH4XZWMXBMKT1QG55XNXTVZ3SRDP5USQC5IQ2POIANE&client_secret=MPURINUKRFOEDVGXLRBG23RBW3KNHA1IBN2PWQWQLBJPW5UO&v=20110101')
    # puts resp.response.class
    # puts JSON.pretty_generate(response.to_s.to_json)
    foursquare = Foursquare::Base.new("F2VJIIH4XZWMXBMKT1QG55XNXTVZ3SRDP5USQC5IQ2POIANE", "MPURINUKRFOEDVGXLRBG23RBW3KNHA1IBN2PWQWQLBJPW5UO")
    @venues = foursquare.venues.search(ll: '48.849117,2.4420522', intent: 'browse', radius: '1000')
    @venues["nearby"].each do |venue|
      # puts JSON.pretty_generate(venue.json)
      puts venue.name
    end
  end

end
