class Discussion < ActiveRecord::Base
  acts_as_readable :on => :discussed_at

  belongs_to :user
  belongs_to :canoe
  has_many :opinions
  has_many :proposals do
    def best
      first = self.sort_by(&:point).reverse.first
      if first.present? and first.point > 0
        self.select { |p| p.point == first.point }.sort_by { |p| [p.votes.in_favor.count, p.created_at] }.reverse
      else
        []
      end
    end

    def soso
      self.where.not(id: self.best)
    end
  end

  validates :canoe, presence: true

  before_save :set_discussed_at

  def set_discussed_at
    self.discussed_at = DateTime.now
  end

end
