# == Schema Information
#
# Table name: infos
#
#  id         :integer          not null, primary key
#  content    :string(255)
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  info_type  :string(255)
#

class Info < ActiveRecord::Base
  attr_accessible :content, :info_type
  belongs_to :user

  validates :content, presence: true, length: { maximum: 80 }
  validates :user_id, presence: true
end
