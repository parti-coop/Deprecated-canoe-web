class Crew < ActiveRecord::Base
  attr_accessor :user_key
  belongs_to :user
  belongs_to :host, class_name: User
  belongs_to :canoe

  after_save :clear_invitation
  after_save :clear_request_to_join

  validates :user, uniqueness: {scope: [:canoe]}

  private

  def clear_invitation
    Invitation.of_guest(user).destroy_all
  end

  def clear_request_to_join
    RequestToJoin.where(user: user).destroy_all
  end
end
