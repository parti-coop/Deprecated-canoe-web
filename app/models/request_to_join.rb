class RequestToJoin < ActiveRecord::Base
  belongs_to :user
  belongs_to :canoe
end
