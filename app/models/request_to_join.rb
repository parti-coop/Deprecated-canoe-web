class RequestToJoin < ActiveRecord::Base
  belongs_to :user
  belongs_to :canoe

  def the_concerned_for_messaging
    user
  end
end
