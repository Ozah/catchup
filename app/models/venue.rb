# == Schema Information
#
# Table name: venues
#
#  id            :integer          not null, primary key
#  foursquare_id :string(255)
#  name          :string(255)
#  location      :text
#  icon          :text
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  latitude      :float
#  longitude     :float
#

class Venue < ActiveRecord::Base
	serialize :location

  attr_accessible :foursquare_id, :name, :location, :latitude, :longitude, :icon

  reverse_geocoded_by :latitude, :longitude

  has_many :places
  has_many :users, through: :places
  has_many :meetings

  validates_presence_of :name, :latitude, :longitude
end
