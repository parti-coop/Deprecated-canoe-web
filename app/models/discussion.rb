class Discussion < ActiveRecord::Base
  include PublicActivity::Model
  include DiscussionActivityTraking

  acts_as_paranoid
  acts_as_sequenced scope: :canoe_id
  acts_as_readable on: :discussed_at

  belongs_to :user
  belongs_to :canoe
  has_many :opinions
  has_many :proposals do
    def top_of_votes_count(choice)
      top_of_count = self.max_votes_count(choice)
      top_of_count = -1 if top_of_count == 0
      top_of_count
    end

    def max_votes_count(choice)
      self.maximum("#{choice}_votes_count")
    end
  end
  has_many :attachments, as: :attachable

  validates :canoe, presence: true
  cattr_accessor :skip_callbacks
  before_save :set_discussed_at, unless: :skip_callbacks
  scope :valid_parent, -> { joins(:canoe) }
  scoped_search on: %w(subject decision)
  scoped_search in: :opinions, on: %w(body)
  scoped_search in: :proposals, on: %w(body)
  accepts_nested_attributes_for :opinions

  def set_discussed_at
    self.discussed_at = DateTime.now
  end

  def activities_merged
    Hash[activities.order(created_at: :desc)
      .slice_when{ |a, b| !a.meargable_in_timeline?(b) }
      .map { |chunk| [chunk.first, zip_activities(chunk)] }]
  end

  private

  def zip_activities(chunk)
    groups_by_subject = chunk.group_by(&:subject).map do |subject, activities|
      result = activities.sort_by(&:created_at)

      vote_activities = result.select{ |a| a.measure_type == Vote.to_s }
      if (vote_activities.count > 2)
        if vote_activities.first.task == vote_activities.last.task
          result -= vote_activities[1..-1]
        else
          result -= vote_activities[1...-1]
        end
      end

      proposal_update_activities = result.select{ |a| a.key == 'proposal' and a.task == 'update' }
      result -= proposal_update_activities[0...-1] if (proposal_update_activities.count > 1)

      discussion_decision_update_activities = result.select{ |a| a.key == 'discussion.decision' and a.task == 'update' }
      result -= discussion_decision_update_activities[0...-1] if (discussion_decision_update_activities.count > 1)

      {subject: subject, activities: result}
    end

    groups_by_subject.slice_when{ |a, b| !meargable_in_timeline_status? a, b }
  end

  def meargable_in_timeline_status?(m, n)
    return false unless m[:subject].class.to_s == n[:subject].class.to_s
    return false unless m[:subject].class.to_s == Proposal.to_s
    return false if m[:activities].any? { |a| a.measure_type == Attachment.to_s }
    return false if n[:activities].any? { |a| a.measure_type == Attachment.to_s }
    return m[:activities].map(&:key) == n[:activities].map(&:key)
  end
end
