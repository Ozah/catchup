# == Schema Information
#
# Table name: notes
#
#  id         :integer          not null, primary key
#  content    :string(255)
#  user_id    :integer
#  meeting_id :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Note < ActiveRecord::Base
  attr_accessible :content, :user_id, :meeting_id

  belongs_to :user
  belongs_to :meeting

  validates :content, presence: true, length: { maximum: 80 }
  validates :user_id, presence: true
  validates :meeting_id, presence: true
end
