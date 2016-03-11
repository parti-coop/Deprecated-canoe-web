class Api::V1::DiscussionSerializer < ActiveModel::Serializer
  attributes(*Discussion.attribute_names.map(&:to_sym))
  attributes(:activities)
  has_one :canoe
  has_many :proposals

  def activities
    activities = object.activities_merged
    activities.map do |first_activity, activities_groups|
      if first_activity.key == 'opinion'
        opinion = first_activity.subject
        {
          type: 'opinion',
          user: opinion.user,
          items: [opinion]
        }
      else
        {
          type: 'activity',
          user: first_activity.owner,
          items: activities_groups
        }
      end
    end
  end
end
