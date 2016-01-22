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
  end
end
