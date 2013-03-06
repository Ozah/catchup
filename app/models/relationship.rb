# == Schema Information
#
# Table name: relationships
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  contact_id :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Relationship < ActiveRecord::Base
  attr_accessible :contact_id, :user_id

  belongs_to :user
  belongs_to :contact, class_name: "User"

  validates :user,    presence: true
  validates :contact, presence: true
end
