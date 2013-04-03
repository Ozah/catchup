# == Schema Information
#
# Table name: meetings
#
#  id         :integer          not null, primary key
#  latitude   :float
#  longitude  :float
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  venue_id   :integer
#

class Meeting < ActiveRecord::Base
  attr_accessible :latitude, :longitude, :location

  reverse_geocoded_by :latitude, :longitude

  has_many :handshakes
  has_many :users, through: :handshakes
  has_many :notes, dependent: :destroy
  belongs_to :venue

  validates_presence_of :latitude, :longitude
end
