class Opinion < ActiveRecord::Base
  include DiscussionComponent
  belongs_to :user
end
