class Discussion < ActiveRecord::Base
  belongs_to :user
  belongs_to :canoe
  has_many :opinions
end
