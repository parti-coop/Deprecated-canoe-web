class Opinion < ActiveRecord::Base
  include DiscussionComponent
  belongs_to :user
  has_many :mentions
  has_many :reactions
  before_save :set_mentions

  private

  def set_mentions
    mention_texts ||= begin
      regex = /@([\w]+)/
      body.scan(regex).flatten
    end

    self.mentions.destroy_all
    mention_texts.uniq.each do |mention_text|
      user = User.find_or_sync_by_nickname(mention_text)
      self.mentions.build(user: user)
    end
  end
end
