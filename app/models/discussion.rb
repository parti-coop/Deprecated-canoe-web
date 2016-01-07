class Discussion < ActiveRecord::Base
  belongs_to :user
  belongs_to :canoe
  has_many :opinions do
    def pinned
      self.where(pinned: true)
    end
  end
  has_many :proposals do
    def tops
      first = self.sort_by(&:point).reverse.first
      if first.present? and first.point > 0
        self.select { |p| p.point == first.point }.sort_by { |p| [p.votes.in_favor.count, p.created_at] }.reverse
      else
        []
      end
    end

    def bottoms
      self.where.not(id: self.tops)
    end
  end

  before_save :set_discussed_at

  def set_discussed_at
    self.discussed_at = DateTime.now
  end
end
