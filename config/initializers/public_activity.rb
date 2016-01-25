Rails.application.config.to_prepare do
  PublicActivity::Activity.class_eval do
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

    def separated_with?(other)
      return true if (self.key == 'opinions.create' or other.key == 'opinions.create')
      return true if self.owner != other.owner

      if TimeDifference.between(self.created_at, other.created_at).in_minutes.abs <= 5
        return false
      end
      if !self.created_at.today? and self.created_at.to_date == other.created_at.to_date
        return false
      end

      return true
    end
  end
end
