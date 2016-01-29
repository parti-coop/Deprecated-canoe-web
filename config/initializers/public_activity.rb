Rails.application.config.to_prepare do
  PublicActivity::Activity.class_eval do
    belongs_to :subject, -> { unscope(where: :deleted_at) }, polymorphic: true
    belongs_to :measure, -> { unscope(where: :deleted_at) }, polymorphic: true
    def trackable_with_deleted
      return if trackable_type.blank?
      model = trackable_type.classify.constantize.with_deleted
      model.find_by id: trackable_id
    end

    def recipient_with_deleted
      return if recipient_type.blank?
      model = recipient_type.classify.constantize.with_deleted
      model.find_by id: recipient_id
    end

    def meargable_in_timeline?(other)
      return false if (self.key == 'opinion' or other.key == 'opinion')
      return false if self.owner != other.owner

      if TimeDifference.between(self.created_at, other.created_at).in_minutes.abs <= 5
        return true
      end
      if !self.created_at.today? and self.created_at.to_date == other.created_at.to_date
        return true
      end

      return false
    end
  end
end
