class Advertisement < ActiveRecord::Base
  has_many :comment, dependent: :destroy
  belongs_to :user
  mount_uploader :image, ImageUploader
  validates :content, presence: true
  validates :image, presence: true
end
