Rails.application.config.to_prepare do
  User.class_eval do
    acts_as_reader

    has_many :crews
    has_many :canoes
    has_many :crewing_canoes, class_name: Canoe, through: :crews, source: :canoe
    has_many :crewing_discussions, class_name: Discussion, through: :crewing_canoes, source: :discussions do
      def read
        self.read_by(proxy_association.owner)
      end
      def unread
        self.unread_by(proxy_association.owner)
      end
    end
    has_many :crewing_proposals, class_name: Proposal, through: :crewing_canoes, source: :proposals
  end
end
