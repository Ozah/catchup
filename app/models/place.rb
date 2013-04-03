# == Schema Information
#
# Table name: places
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  venue_id   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Place < ActiveRecord::Base
  attr_accessible :user_id, :venue_id

  belongs_to :user
  belongs_to :venue

  validates_presence_of :user, :venue
end
