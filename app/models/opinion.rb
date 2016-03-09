class Opinion < ActiveRecord::Base
  acts_as_paranoid
  include CanoeTimestampable
  counter_culture [:discussion, :canoe]

  belongs_to :user
  belongs_to :discussion
  has_one :canoe, through: :discussion
  has_many :mentions
  has_many :reactions
  has_many :attachments, as: :attachable
  accepts_nested_attributes_for :attachments

  before_save :set_mentions

  default_scope { order("created_at DESC") }
  scoped_search on: %w(body)

  validates :body, presence: true

  def timestamp_user
    self.user
  end

  private

  def set_mentions
    self.mentions.destroy_all
    Mention.scan_users_from(self).each do |user|
      self.mentions.build(user: user)
    end
  end
end
