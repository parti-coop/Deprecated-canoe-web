class Opinion < ActiveRecord::Base
  acts_as_paranoid
  include DiscussionComponent

  belongs_to :user
  has_many :mentions
  has_many :reactions
  before_save :set_mentions
  has_many :attachments, as: :attachable

  default_scope { order("created_at DESC") }
  accepts_nested_attributes_for :attachments

  validates :body, presence: true

  private

  def set_mentions
    self.mentions.destroy_all
    Mention.scan_users_from(self).each { |user| self.mentions.build(user: user) }
  end
end
