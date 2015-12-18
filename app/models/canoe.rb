class Canoe < ActiveRecord::Base
  belongs_to :user
  has_many :discussions
end
