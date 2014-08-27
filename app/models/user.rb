class User < ActiveRecord::Base
  rolify
  #before_save :set_provider
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,:recoverable, :rememberable,
  :trackable, :validatable, :omniauthable, :omniauth_providers => [:facebook]
  #associations
  has_many :advertisement, dependent: :destroy
  has_many :comment, dependent: :destroy
  #has_and_belongs_to_many :roles
  belongs_to :role
#logging from facebook
  def self.from_omniauth(auth)
    where(auth.slice(:provider, :uid)).first_or_create do |user|
    user.email = auth.info.email
    user.password = Devise.friendly_token[0,20]
    user.login = auth.info.name
    end
  end

  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
        user.email = data["email"] if user.email.blank?
      end
    end
  end
#geocoding
  geocoded_by :full_address
  after_validation :geocode

  def full_address
    [address, city, state, country].compact.join(', ')
  end

  #validations
  #validates :address, presence: true
 # validates :login, presence: true
 after_create :assign_user_role
 rolify
 private

  def assign_user_role
    self.add_role "user"
  end
end
