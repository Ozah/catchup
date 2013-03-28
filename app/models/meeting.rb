# == Schema Information
#
# Table name: meetings
#
#  id         :integer          not null, primary key
#  latitude   :float
#  longitude  :float
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  location   :string(255)
#

class Meeting < ActiveRecord::Base
  attr_accessible :latitude, :longitude, :location

  reverse_geocoded_by :latitude, :longitude

  has_many :handshakes
  has_many :users, through: :handshakes
  has_many :notes

end
