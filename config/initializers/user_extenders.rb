Rails.application.config.to_prepare do
  User.class_eval do
    has_many :crews
    has_many :canoes
    has_many :crewing_canoes, class_name: Canoe, through: :crews, source: :canoe
    has_many :crewing_discussions, class_name: Discussion, through: :crewing_canoes, source: :discussions
    has_many :crewing_proposals, class_name: Proposal, through: :crewing_canoes, source: :proposals
  end
end
