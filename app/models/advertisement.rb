class Advertisement < ApplicationRecord
  has_many :comment, dependent: :destroy
  belongs_to :category, optional: true
  belongs_to :user
  mount_uploader :image, ImageUploader
  validates :content, presence: true, length: { maximum: 1000 }
  #validates :title, presence: true
  #validates :image, presence: true, if: "remote_image_url.blank?"
  #validates :remote_image_url, presence: true, if: "image.blank?"
  validates :user, presence: true
  resourcify
  #mount_uploader :content, ContentUploader
  #serialize :content, JSON
  # Case-insensitive substring search on title and content. Plain LIKE so it
  # works on both SQLite (dev/test) and PostgreSQL; % and _ in the query are
  # matched literally.
  def self.text_search(query)
    return all if query.blank?

    pattern = "%#{sanitize_sql_like(query.strip.downcase)}%"
    where("LOWER(title) LIKE :q ESCAPE '\\' OR LOWER(content) LIKE :q ESCAPE '\\'", q: pattern)
  end
end
