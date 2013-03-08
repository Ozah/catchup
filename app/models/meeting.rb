# == Schema Information
#
# Table name: meetings
#
#  id         :integer          not null, primary key
#  latitude   :float
#  longitude  :float
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Meeting < ActiveRecord::Base
  attr_accessible :latitude, :longitude

  has_many :handshakes
  has_many :users, through: :handshakes

end
