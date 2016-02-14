class Discussion < ActiveRecord::Base
  include PublicActivity::Model
  include CanoeTimestampable

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

  attr_accessor :current_activity_user
  cattr_accessor :skip_callbacks
  before_create :init_discussed_at, unless: :skip_callbacks

  scope :valid_parent, -> { joins(:canoe) }
  scope :persisted, -> { where "id IS NOT NULL" }
  scoped_search on: %w(subject decision)
  scoped_search in: :opinions, on: %w(body)
  scoped_search in: :proposals, on: %w(body)
  accepts_nested_attributes_for :opinions

  def init_discussed_at
    self.discussed_at = DateTime.now
    user.touch(:home_visited_at)
  end

  def discussion
    self
  end

  def activities_merged
    Hash[activities.order(created_at: :asc)
      .slice_when{ |a, b| !meargable_in_timeline?(a, b) }
      .map { |chunk| [chunk.first, zip_activities(chunk)] }]
  end

  def newest_proposal_or_opinion(q = nil)
    if q.present?
      newest_proposal = proposals.search_for(q).newest
      newest_opinion = opinions.search_for(q).newest
    else
      newest_proposal = proposals.newest
      newest_opinion = opinions.newest
    end

    return newest_opinion if newest_proposal.nil?
    return newest_proposal if newest_opinion.nil?
    (newest_proposal.created_at > newest_opinion.created_at) ? newest_proposal : newest_opinion
  end

  def updated_decision?
    activities.today.where(key: 'discussion.decision', task: 'update').any?
  end

  def timestamp_user
    current_activity_user
  end

  private

  def meargable_in_timeline?(m, n)
    return false if (m.key == 'opinion' or n.key == 'opinion')
    return false if m.owner != n.owner

    if TimeDifference.between(m.created_at, n.created_at).in_minutes.abs <= 5
      return true
    end
    if !m.created_at.today? and m.created_at.to_date == n.created_at.to_date
      return true
    end

    return false
  end

  def zip_activities(chunk)
    chunk.group_by(&:subject).map do |subject, activities|
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
  end
end
