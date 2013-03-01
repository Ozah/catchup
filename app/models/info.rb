class Info < ActiveRecord::Base
  attr_accessible :content
  belongs_to :user

  validates :content, presence: true, length: { maximum: 80 }
  validates :user_id, presence: true
end
