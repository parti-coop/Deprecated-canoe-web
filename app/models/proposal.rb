class Proposal < ActiveRecord::Base
  acts_as_sequenced scope: :discussion_id

  belongs_to :user
  include DiscussionComponent

  has_many :votes do
    def percentage(choice)
      self.send(choice).count.to_f / self.count * 100
    end

    def point
      self.in_favor.count - self.opposed.count
    end
  end

  scope :latest, -> { order(id: :desc) }

  def voted?(user, choice = nil)
    (choice.nil? ? votes : votes.send(choice)).exists? user: user
  end

  def best?
    discussion.proposals.best.include? self
  end

  def point
    votes.point
  end
end
