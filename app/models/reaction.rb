class Reaction < ActiveRecord::Base
  extend Enumerize

  belongs_to :user
  belongs_to :opinion
  enumerize :token, in: [:smile, :flushed, :disappointed_relieved, :scream, :rage, :'+1', :'-1', :ok_hand, :wave, :coffee, :dancers]

  scope :by_token, ->(token) { where(token: token) }

  def self.duplicated?(new_reaction)
    self.exists?(opinion: new_reaction.opinion, user: new_reaction.user, token: new_reaction.token)
  end

  def self.pluck_users(options = {})
    self.includes(:user).where(options).map(&:user)
  end
end
