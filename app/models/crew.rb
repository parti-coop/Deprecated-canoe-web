class Crew < ActiveRecord::Base
  attr_accessor :user_key
  belongs_to :user
  belongs_to :inviter, class_name: User
  belongs_to :canoe
end
