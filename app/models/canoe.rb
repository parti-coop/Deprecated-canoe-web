class Canoe < ActiveRecord::Base
  belongs_to :user
  has_many :discussions
  has_many :opinions, through: :discussions

  validates :title, presence: true
  VALID_SLUG = /\A[a-z0-9]+\z/i
  validates :slug,
    presence: true,
    format: { with: VALID_SLUG },
    exclusion: { in: %w(app new edit index session login logout users admin
    stylesheets assets javascripts images) },
    uniqueness: { case_sensitive: true },
    length: { maximum: 100 }
end
