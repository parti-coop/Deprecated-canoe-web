class Canoe < ActiveRecord::Base
  belongs_to :user
  has_many :discussions
  has_many :opinions, through: :discussions
  has_many :crews

  mount_uploader :logo, ImageUploader
  mount_uploader :cover, ImageUploader


  validates :title, presence: true
  VALID_SLUG = /\A[a-z0-9_-]+\z/i
  validates :slug,
    presence: true,
    format: { with: VALID_SLUG },
    exclusion: { in: %w(app new edit index session login logout users admin
    stylesheets assets javascripts images) },
    uniqueness: { case_sensitive: true },
    length: { maximum: 100 }

  scope :latest, -> { order(id: :desc) }
  def crew?(target)
    user == target or crews.exists? user: target
  end
end
