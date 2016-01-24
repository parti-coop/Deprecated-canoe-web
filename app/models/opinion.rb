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

  private

  def set_mentions
    mention_texts ||= begin
      regex = /\s@([\w]+)/
      body.scan(regex).flatten
    end

    self.mentions.destroy_all
    mention_texts.uniq.each do |mention_text|
      user = User.find_or_sync_by_nickname(mention_text)
      self.mentions.build(user: user) if user.present?
    end
  end
end
