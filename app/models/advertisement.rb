class Advertisement < ActiveRecord::Base
  include PgSearch
  pg_search_scope :search_by_content, :against => [:content, :author]
  has_many :comment, dependent: :destroy
  belongs_to :category
  belongs_to :user
  mount_uploader :image, ImageUploader
  #validates :content, presence: true, length: { maximum: 1000 }
  #validates :title, presence: true
  #validates :image, presence: true, if: "remote_image_url.blank?"
  #validates :remote_image_url, presence: true, if: "image.blank?"
  resourcify
  #mount_uploader :content, ContentUploader
  #serialize :content, JSON
  def self.text_search(query)
    if query.present?
      search_by_content(query)
    else
      scoped
    end
  end
end
