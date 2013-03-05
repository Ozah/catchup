# == Schema Information
#
# Table name: handshakes
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  meeting_id :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  validated  :boolean          default(FALSE)
#

class Handshake < ActiveRecord::Base
  attr_accessible :meeting_id, :user_id, :validated

  belongs_to :user
  belongs_to :meeting

  validates :user,    presence: true
  validates :meeting, presence: true
end
