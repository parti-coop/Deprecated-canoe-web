class Vote < ActiveRecord::Base
  belongs_to :user
  belongs_to :proposal
  has_one :discussion, through: :proposal
  enum choice: { in_favor: 1, opposed: 2 }

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
