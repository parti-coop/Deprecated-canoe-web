Rails.application.config.to_prepare do
  User.class_eval do
    cattr_accessor :skip_callbacks

    acts_as_reader
    acts_as_messageable

    has_many :crews
    has_many :canoes
    has_many :invitations
    has_many :invited_canoes, class_name: Canoe, through: :invitations, source: :canoe
    has_many :joined_canoes, class_name: Canoe, through: :crews, source: :canoe
    has_many :joined_discussions, class_name: Discussion, through: :joined_canoes, source: :discussions do
      def read
        self.read_by(proxy_association.owner)
      end
      def unread
        self.unread_by(proxy_association.owner)
      end
    end
    has_many :joined_proposals, class_name: Proposal, through: :joined_canoes, source: :proposals

    after_create :set_invitation, unless: :skip_callbacks

    def touch_home
      self.home_visited_at = DateTime.now
    end

    def updated_home?
      return false if joined_discussions.empty?
      home_visited_at < joined_discussions.maximum(:discussed_at)
    end

    private

    def set_invitation
      Invitation.where(email: email, user: nil).each do |invitation|
        invitation.user = self
        invitation.save
      end
    end
  end
end
