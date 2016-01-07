module DiscussionComponent
  extend ActiveSupport::Concern

  included do
    belongs_to :discussion
    after_save :set_discussed_at
    after_destroy :set_discussed_at
  end


  private

  def set_discussed_at
    self.discussion.set_discussed_at
    self.discussion.save!
  end

end
