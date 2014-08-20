class Advertisement < ActiveRecord::Base
  include PgSearch
  pg_search_scope :search_by_content, :against => [:content, :author]
  has_many :comment, dependent: :destroy
  belongs_to :user
  mount_uploader :image, ImageUploader
  validates :content, presence: true
  validates :image, presence: true

  def self.text_search(query)
  if query.present?
     search_by_content(query)
  else
    scoped
  end
end
end
