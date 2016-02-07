Rails.application.config.to_prepare do
  User.class_eval do
    acts_as_reader
    acts_as_messageable

    has_many :crews
    has_many :canoes
    has_many :invitations
    has_many :invited_canoes, class_name: Canoe, through: :invitations, source: :canoe
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

    after_create :set_invitation

    private

    def set_invitation
      Invitation.where(email: email, user: nil).each do |invitation|
        invitation.user = self
        invitation.save
      end
    end
  end
end
