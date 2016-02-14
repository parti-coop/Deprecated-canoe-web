module DiscussionComponent
  extend ActiveSupport::Concern

  attr_accessor(:skip_setting_discussed_at)
  attr_accessor(:skip_setting_sailed_at)
  attr_accessor(:skip_setting_home_visited_at)

  included do
    belongs_to :discussion
    has_one :canoe, through: :discussion
    after_save :set_canoe_timestamps
    after_destroy :set_canoe_timestamps
  end


  private

  def set_canoe_timestamps
    if self.user.updated_home?
      set_discussed_at
    else
      set_discussed_at
      set_home_visited_at
    end

    set_sailed_at
  end

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

  def set_home_visited_at
    return if skip_setting_home_visited_at

    self.user.touch_home
    self.user.save!
  end
end
