class Discussion < ActiveRecord::Base
  include PublicActivity::Model

  acts_as_readable :on => :discussed_at

  belongs_to :user
  belongs_to :canoe
  has_many :opinions
  has_many :proposals do
    def top_of(choice)
      self.where("#{choice}_votes_count": top_of_votes_count(choice))
    end

    def exclude_top_of(choice)
      self.where.not("#{choice}_votes_count": top_of_votes_count(choice))
    end

    def top_of_votes_count(choice)
      top_of_count = self.max_votes_count(choice)
      top_of_count = -1 if top_of_count == 0
      top_of_count
    end

    def max_votes_count(choice)
      self.maximum("#{choice}_votes_count")
    end
  end

  validates :canoe, presence: true
  before_save :set_discussed_at
  accepts_nested_attributes_for :opinions

  def set_discussed_at
    self.discussed_at = DateTime.now
  end

end
