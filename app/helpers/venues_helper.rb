module VenuesHelper
	def get_foursquare_venues(latitude, longitude)
    # client = Foursquare2::Client.new(client_id: 'F2VJIIH4XZWMXBMKT1QG55XNXTVZ3SRDP5USQC5IQ2POIANE', client_secret: 'MPURINUKRFOEDVGXLRBG23RBW3KNHA1IBN2PWQWQLBJPW5UO')
    # resp = client.search_venues(ll: '48.849117,2.4420522', intent: 'browse', radius: '100')
    # response = HTTParty.get('https://api.foursquare.com/v2/venues/search?&ll=48.849117,2.4420522&intent=browse&radius=100&client_id=F2VJIIH4XZWMXBMKT1QG55XNXTVZ3SRDP5USQC5IQ2POIANE&client_secret=MPURINUKRFOEDVGXLRBG23RBW3KNHA1IBN2PWQWQLBJPW5UO&v=20110101')
    # puts resp.response.class
    # puts JSON.pretty_generate(response.to_s.to_json)
    
    foursquare = Foursquare::Base.new("F2VJIIH4XZWMXBMKT1QG55XNXTVZ3SRDP5USQC5IQ2POIANE", "MPURINUKRFOEDVGXLRBG23RBW3KNHA1IBN2PWQWQLBJPW5UO")
    @venues = foursquare.venues.search(
                    ll: "#{latitude},#{longitude}", 
                    # intent: 'browse', 
                    radius: '1000')

  end

  def get_foursquare_venue(id)
  	foursquare = Foursquare::Base.new("F2VJIIH4XZWMXBMKT1QG55XNXTVZ3SRDP5USQC5IQ2POIANE", "MPURINUKRFOEDVGXLRBG23RBW3KNHA1IBN2PWQWQLBJPW5UO")
    @venue = foursquare.venues.find(id)
  end
end
