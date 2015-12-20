class Vote < ActiveRecord::Base
  belongs_to :user
  belongs_to :proposal
  enum choice: { in_favor: 1, opposed: 2 }
end
