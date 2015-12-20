class Discussion < ActiveRecord::Base
  belongs_to :user
  belongs_to :canoe
  has_many :opinions
  has_many :proposals
end
