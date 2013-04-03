# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  name            :string(255)
#  email           :string(255)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  password_digest :string(255)
#  remember_token  :string(255)
#  admin           :boolean          default(FALSE)
#  latitude        :float
#  longitude       :float
#  location_time   :datetime
#  address         :string(255)
#

class User < ActiveRecord::Base
  attr_accessible :name, :email, :password, :password_confirmation,
                  :latitude, :longitude, :location_time
  
  has_secure_password
  reverse_geocoded_by :latitude, :longitude

  has_many :infos, dependent: :destroy
  has_many :relationships
  has_many :contacts, through: :relationships
  has_many :handshakes
  has_many :meetings, through: :handshakes
  has_many :places
  has_many :venues, through: :places

  
  # Ensuring email uniqueness by downcasing the email attribute.
  before_save { email.downcase! }

  # before_save { create_remember_token }

  validates :name,  presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false },
                    allow_blank: true

  validates :remember_token, uniqueness: true

  validates :password, presence: true, length: { in: 6..40 },
                      unless: :already_has_password?
  validates :password_confirmation, presence: true,
                      unless: :already_has_password?
=begin  
  validates :password, presence: true,
                       confirmation: true,
                       length: { within: 6..40 },
                       unless: :already_has_password?

  validates :password_confirmation, presence: true
=end
  

  
  def add_contact!(other_user)
    self.relationships.create!(contact_id: other_user.id) unless self.has_contact?(other_user)
  end

  def has_contact?(other_user)
    self.contacts.include?(other_user)
  end

  def id_and_name
    { id: self.id, name: self.name }
  end

  def update_position(latitude, longitude)
    self.update_attributes(latitude:  latitude,
                           longitude: longitude, 
                           location_time: Time.now)
  end

  def create_remember_token
    done = false
    until done do 
      token = SecureRandom.urlsafe_base64
      #makes sure the remember_token is unique
      unless User.find_by_remember_token(token)
        self.remember_token = token
        self.save
        done = true
      end
    end
  end

  private 
  # def create_remember_token
  #     self.remember_token = SecureRandom.urlsafe_base64
  # end

  def already_has_password?
    !self.password_digest.blank?
  end
    
end
