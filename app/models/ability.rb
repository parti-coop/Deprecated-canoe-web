class Ability
  include CanCan::Ability

  def initialize(user)
    can :read, :all
    if user
      can :create, Canoe
      can :update, Canoe do |canoe|
        canoe.crew? user
      end
      can :manage, Canoe do |canoe|
        canoe.user == user
      end

      can [:create, :update], Discussion do |discussion|
        discussion.canoe.crew? user
      end
      can :manage, Discussion do |discussion|
        discussion.user == user
      end

      can :create, Opinion do |opinion|
        opinion.discussion.canoe.crew? user
      end
      can :manage, Opinion do |opinion|
        opinion.user == user
      end

      can :show_result, Proposal do |proposal|
        proposal.votes.any? and proposal.voted?(user)
      end
      can :create, Proposal do |proposal|
        proposal.discussion.canoe.crew? user
      end
      can [:update, :destroy], Proposal do |proposal|
        proposal.user == user
      end

      can :accept_crew, Canoe do |canoe|
        canoe.crew? user
      end
      can :ask_crew, Canoe do |canoe|
        !canoe.crew?(user) and !canoe.request_to_join?(user)
      end
      can :manage, Crew do |crew|
        crew.canoe.crew?(user)
      end

      can :in_favor, Proposal do |proposal|
        proposal.voted?(user, :in_favor)
      end
      can :opposed, Proposal do |proposal|
        proposal.voted?(user, :opposed)
      end
      can :unvote, Proposal do |proposal|
        proposal.voted?(user)
      end
    end
  end
end