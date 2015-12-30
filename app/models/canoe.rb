class Canoe < ActiveRecord::Base
  belongs_to :user
  has_many :discussions
  has_many :opinions, through: :discussions
  has_many :crews do
    def exclude_captain
      self.where.not(user: proxy_association.owner.user)
    end
  end
  has_many :request_to_joins

  mount_uploader :logo, ImageUploader
  mount_uploader :cover, ImageUploader

  before_create :add_captain_to_crew

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
    crews.exists? user: target
  end

  def request_to_join?(target)
    request_to_joins.exists? user: target
  end

  def assure_that_captain_is_crew
    unless crews.exists?(user: self.user)
      add_captain_to_crew
    end
  end

  private

  def add_captain_to_crew
    self.crews.build(user: self.user, inviter: self.user)
  end
end
