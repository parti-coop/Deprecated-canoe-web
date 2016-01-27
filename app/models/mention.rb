class Mention < ActiveRecord::Base
  belongs_to :user
  belongs_to :opinion

  PATTERN = /(?:^|\s)@([\w]+)/
  PATTERN_WITH_AT = /(?:^|\s)(@[\w]+)/

  def self.scan_users_from(opinion)
    return [] if opinion.body.blank?
    result = begin
      opinion.body.scan(PATTERN).flatten
    end
    result.uniq.map { |nickname| User.find_or_sync_by_nickname(nickname) }.compact
  end
end
