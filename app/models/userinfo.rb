class Userinfo < ActiveRecord::Base
  belongs_to :user
  geocoded_by :full_address
  def full_address
  [address, city, state, country].compact.join(', ')
  end
  after_validation :geocode, :if => :address_changed?
end
