class Proposal < ActiveRecord::Base
  include DiscussionComponent

  acts_as_paranoid
  acts_as_sequenced scope: :discussion_id

  belongs_to :user
  has_one :canoe, through: :discussion
  has_many :attachments, as: :attachable

  has_many :votes do
    def by_crews
      self.where(user: proxy_association.owner.canoe.crews_as_user)
    end

    def by_guests
      self.where.not(user: proxy_association.owner.canoe.crews_as_user)
    end
  end
  has_many :in_favor_votes, -> { where choice: :in_favor }, class_name: Vote, counter_cache: 'in_favor_votes_count'

  validates :body, presence: true
  scope :latest, -> { order(id: :desc) }
  accepts_nested_attributes_for :attachments

  def opposed_by? user
    voted_by?(user, :opposed)
  end

  def in_favor_by? user
    voted_by?(user, :in_favor)
  end

  def voted_by?(user, choice = nil)
    (choice.nil? ? votes : votes.with_choice(choice)).exists? user: user
  end

  def votes_count(choice)
    send(:"#{choice}_votes_count")
  end

  def best?(choice)
    discussion.proposals.top_of_votes_count(choice) == self.votes_count(choice)
  end

  def in_favor_percentage_by_crews
    votes.in_favor.by_crews.count.to_f / canoe.crews.count * 100
  end

end
