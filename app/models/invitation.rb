class Invitation < ActiveRecord::Base
  attr_accessor :user_key

  belongs_to :user
  belongs_to :host, class_name: User
  belongs_to :canoe

  validates :user, uniqueness: {scope: [:canoe]}
  validates :email, presence: true

  default_scope { order("created_at DESC") }
  scope :persisted, -> { where "id IS NOT NULL" }

  def guest_image_url
    user.try(:image_url)
  end

  def guest_nickname
    user.try(:nickname) || email
  end

  def self.of_guest(someone)
    where.any_of({user: someone}, {email: someone.email})
  end
end
