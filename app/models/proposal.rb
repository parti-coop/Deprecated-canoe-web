class Proposal < ActiveRecord::Base
  belongs_to :user
  belongs_to :discussion
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

  def top?
    discussion.proposals.top == self
  end

  def point
    votes.point
  end
end
