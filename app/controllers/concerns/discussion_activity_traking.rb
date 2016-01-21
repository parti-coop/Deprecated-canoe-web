# TEST web hook url : "https://hooks.slack.com/services/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"

module DiscussionActivityTraking
  extend ActiveSupport::Concern

  def create_discussions_update_decision_activty(discussion)
    discussion.create_activity(key: 'discussions.update_decision', owner: current_user, recipient: discussion)
  end

  def create_opinions_create_activty(opinion)
    discussion = opinion.discussion
    discussion.create_activity(key: 'opinions.create', owner: current_user, recipient: opinion)
  end

  def create_votes_in_favor_activty(vote)
    discussion = vote.proposal.discussion
    discussion.create_activity(key: 'votes.in_favor', owner: current_user, recipient: vote)
  end

  def create_votes_opposed_activty(vote)
    discussion = vote.proposal.discussion
    discussion.create_activity(key: 'votes.opposed', owner: current_user, recipient: vote)
  end

  def create_porposals_create_activty(proposal)
    discussion = proposal.discussion
    discussion.create_activity(key: 'proposals.create', owner: current_user, recipient: proposal)
  end

  def create_porposals_update_activty(proposal)
    discussion = proposal.discussion
    discussion.create_activity(key: 'proposals.update', owner: current_user, recipient: proposal)
  end
end
