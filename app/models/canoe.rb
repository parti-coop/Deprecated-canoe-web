class Canoe < ActiveRecord::Base
  belongs_to :user
  has_many :discussions
  has_many :opinions, through: :discussions
end
