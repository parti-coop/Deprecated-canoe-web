class User < ActiveRecord::Base
  acts_as_paranoid
  acts_as_reader
  acts_as_messageable

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable,
         :confirmable, :omniauthable, :omniauth_providers => [:facebook, :google_oauth2, :twitter]

  # validations
  VALID_NICKNAME_REGEX = /\A[a-z0-9_]+\z/i
  validates :nickname,
    presence: true,
    exclusion: { in: %w(parti app new canoe catan edit index session login logout users admin all crew issue group) },
    format: { with: VALID_NICKNAME_REGEX },
    uniqueness: { case_sensitive: false },
    length: { maximum: 20 }
  validate :nickname_exclude_pattern
  validates :email,
    presence: true,
    format: { with: Devise.email_regexp }

  validates :uid, uniqueness: {scope: [:provider]}
  validates :password,
    presence: true,
    confirmation: true,
    length: Devise.password_length,
    if: :password_required?

  validates_confirmation_of :password, if: :password_required?
  validates_length_of       :password, within: Devise.password_length, allow_blank: true

  # auth filters
  before_save :downcase_nickname
  before_save :set_uid
  before_validation :strip_whitespace, only: :nickname
  before_save :ensure_authentication_token, if: Proc.new { |user| !User.skip_callbacks and (user.confirmed_at_changed? and user.confirmed_at.present? and user.authentication_token.blank?) }

  # canoe filters
  after_create :set_invitation, unless: :skip_callbacks
  before_create :set_home_visited_at, unless: :skip_callbacks

  # attrs
  attr_encrypted :authentication_token, key: Rails.application.secrets.secret_key_base

  # associations
  has_many :crews
  has_many :canoes
  has_many :invitations
  has_many :invited_canoes, class_name: Canoe, through: :invitations, source: :canoe
  has_many :joined_canoes, class_name: Canoe, through: :crews, source: :canoe
  has_many :joined_discussions, class_name: Discussion, through: :joined_canoes, source: :discussions do
    def read
      self.read_by(proxy_association.owner)
    end
    def unread
      self.unread_by(proxy_association.owner)
    end
  end
  has_many :joined_proposals, class_name: Proposal, through: :joined_canoes, source: :proposals

  ## uploaders
  # mount
  mount_uploader :image, UserImageUploader

  # scopes
  scope :latest, -> { after(1.day.ago) }

  cattr_accessor :skip_callbacks

  # canoe methods

  def touch_home
    self.home_visited_at = DateTime.now
  end

  def updated_home?
    return false if joined_discussions.empty?
    home_visited_at < joined_discussions.maximum(:discussed_at)
  end

  # auth methodes
  def admin?
    if Rails.env.staging? or Rails.env.production?
      %w(pinkcrimson@gmail.com jennybe0117@gmail.com rest515@parti.xyz berry@parti.xyz royjung@parti.xyz mozolady@gmail.com dalikim@parti.xyz lulu@parti.xyz).include? email
    else
      %w(admin@test.com).include? email
    end
  end

  def send_devise_notification(notification, *args)
    devise_mailer.send(notification, self, *args).deliver_later
  end

  def self.parse_omniauth(data)
    {provider: data['provider'], uid: data['uid'], email: data['info']['email'], image: data['info']['image']}
  end

  def self.find_for_omniauth(auth)
    where(provider: auth[:provider], uid: auth[:uid]).first
  end

  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    email = conditions.delete(:email)
    where(conditions.to_h).where(["provider = 'email' AND uid = :value", { :value => email.downcase }]).first
  end

  def self.new_with_session(params, session)
    resource = super
    auth = session["devise.omniauth_data"]
    if auth.present?
      resource.assign_attributes(auth)
      resource.password = Devise.friendly_token[0,20]
      resource.confirmed_at = DateTime.now
      resource.remote_image_url = auth['image']
    else
      resource.provider = 'email'
    end
    resource
  end

  private

  # canoe methods

  def set_invitation
    Invitation.where(email: email, user: nil).each do |invitation|
      invitation.user = self
      invitation.save
    end
  end

  def set_home_visited_at
    self.home_visited_at = DateTime.now
  end

  def self.find_by_key(key)
    self.find_by(nickname: key) || self.find_by(email: key)
  end

  # auth methods

  def downcase_nickname
    self.nickname = nickname.downcase
  end

  def set_uid
    self.uid = self.email if self.provider == 'email'
  end

  def nickname_exclude_pattern
    self.nickname !~ /\Aparti.*\z/i
  end

  def password_required?
    !persisted? || !password.nil? || !password_confirmation.nil?
  end

  def strip_whitespace
    self.nickname = self.nickname.strip unless self.nickname.nil?
  end

  def ensure_authentication_token
    loop do
      self.authentication_token = Devise.friendly_token
      break unless User.exists?(encrypted_authentication_token: self.encrypted_authentication_token)
    end
  end
end
