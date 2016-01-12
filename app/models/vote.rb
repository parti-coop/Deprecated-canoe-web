class Vote < ActiveRecord::Base
  belongs_to :user
  belongs_to :proposal
  has_one :discussion, through: :proposal
  enum choice: { in_favor: 1, opposed: 2 }
end
