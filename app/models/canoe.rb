class Canoe < ActiveRecord::Base
  extend Enumerize

  acts_as_paranoid
  has_paper_trail on: :update, only: [:title, :theme, :logo, :cover, :slack_webhook_url, :is_able_to_request_to_join]

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

  cattr_accessor :skip_callbacks
  before_save :set_sailed_at, unless: :skip_callbacks

  default_scope -> { order(sailed_at: :desc)}
  scoped_search on: %w(title theme slug)

  def set_sailed_at
    self.sailed_at = DateTime.now
  end

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
    return false unless someone.present?
    invitations.exists?(user: someone) or invitations.exists?(email: someone.email)
  end

  def is_able_to_request_to_join?
    is_able_to_request_to_join
  end

  private

  def add_captain_to_crew
    self.crews.build(user: self.user, host: self.user)
  end
end
