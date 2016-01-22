class Vote < ActiveRecord::Base
  acts_as_paranoid
  extend Enumerize

  belongs_to :user
  belongs_to :proposal
  has_one :discussion, through: :proposal
  enumerize :choice, in: [:in_favor, :opposed], predicates: true, scope: true

  validates :user, uniqueness: {scope: [:proposal, :deleted_at]}

  scope :in_favor, -> { where(choice: 'in_favor') }
  scope :opposed, -> { where(choice: 'opposed') }

  counter_culture :proposal,
    column_name: Proc.new { |model|
      if model.in_favor?
        'in_favor_votes_count'
      elsif model.opposed?
        'opposed_votes_count'
      else
        nil
      end
    },
    column_names: {
      ["votes.choice = ?", 1] => 'in_favor_votes_count',
      ["votes.choice = ?", 2] => 'opposed_votes_count', }
end
