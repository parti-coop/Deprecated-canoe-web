module CanoeTimestampable
  extend ActiveSupport::Concern

  included do
    after_save :touch_canoe_timestamps
    after_destroy :touch_canoe_timestamps
  end

  private

  def current_user
    self.discussion.last_activity.owner
  end

  def touch_canoe_timestamps
    if current_user.try(:updated_home?)
      touch_discussed_at
    else
      touch_discussed_at
      touch_home_visited_at
    end

    touch_sailed_at
  end

  def touch_discussed_at
    return unless self.discussion.present?
    return if Discussion.skip_callbacks
    self.discussion.touch(:discussed_at)
  end

  def touch_sailed_at
    return if Canoe.skip_callbacks
    self.discussion.canoe.touch(:sailed_at)
  end

  def touch_home_visited_at
    return if User.skip_callbacks

    if current_user.present?
      current_user.touch(:home_visited_at)
    end
  end
end
