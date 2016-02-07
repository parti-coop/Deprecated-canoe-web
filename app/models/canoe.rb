class Canoe < ActiveRecord::Base
  extend Enumerize

  acts_as_paranoid

  belongs_to :user
  has_many :discussions
  has_many :opinions, through: :discussions
  has_many :proposals, through: :discussions
  has_many :crews do
    def exclude_captain
      self.where.not(user: proxy_association.owner.user)
    end
  end
  has_many :crews_as_user, through: :crews, class_name: User, source: :user
  has_many :request_to_joins
  has_many :invitations
  enumerize :how_to_join, in: [:public_join, :private_join], predicates: true, scope: true

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
  scoped_search on: %w(title theme slug)

  def captain?(someone)
    user == someone
  end

  def crew?(someone)
    crews.exists? user: someone
  end

  def request_to_join?(someone)
    request_to_joins.exists? user: someone
  end

  def assure_that_captain_is_crew
    unless crews.exists?(user: self.user)
      add_captain_to_crew
    end
  end

  def invited?(someone)
    invitations.exists?(user: someone) or invitations.exists?(email: someone.email)
  end

  private

  def add_captain_to_crew
    self.crews.build(user: self.user, host: self.user)
  end
end
