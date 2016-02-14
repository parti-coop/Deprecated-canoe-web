module DiscussionComponent
  extend ActiveSupport::Concern

  attr_accessor(:skip_setting_discussed_at)
  attr_accessor(:skip_setting_sailed_at)

  included do
    belongs_to :discussion
    has_one :canoe, through: :discussion
    after_save :set_discussed_at
    after_destroy :set_discussed_at
    after_save :set_sailed_at
    after_destroy :set_sailed_at
  end


  private

  def set_discussed_at
    return if skip_setting_discussed_at
    self.discussion.set_discussed_at
    self.discussion.save!
  end

  def set_sailed_at
    return if skip_setting_sailed_at
    self.discussion.canoe.set_sailed_at
    self.discussion.canoe.save!
  end

end
