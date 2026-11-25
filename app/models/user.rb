class User < ApplicationRecord
  #rolify
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,:recoverable, :rememberable,
  :trackable, :validatable
  #associations
  has_many :advertisement, dependent: :destroy
  has_many :comment, dependent: :destroy

  ADDRESS_FIELDS = %w[address city state country].freeze

  # Look the coordinates up (Nominatim, see config/initializers/geocoder.rb) only
  # when the address is new or has changed, not on every save.
  geocoded_by :full_address
  after_validation :geocode, if: :address_changed_for_geocoding?

  def full_address
    [address, city, state, country].compact.join(', ')
  end

  #validations
  validates :address, :city, :country, :state, :bday, :full_name, :login,
            presence: true, length: { maximum: 150 }
  validates :zip, presence: true, length: { maximum: 10 }, format: { with: /\A[-\d]+\z/ }

  before_create :assign_user_role
  rolify


  private

  def address_changed_for_geocoding?
    full_address.present? && (ADDRESS_FIELDS & changed).any?
  end

  def assign_user_role
    self.add_role "user"
  end
end
