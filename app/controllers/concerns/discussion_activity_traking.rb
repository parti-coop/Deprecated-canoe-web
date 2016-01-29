module DiscussionActivityTraking
  extend ActiveSupport::Concern

  def create_discussions_update_decision_activty(discussion)
    discussion.create_activity(key: 'discussion.decision',
      task: 'update',
      subject: discussion,
      owner: current_user)
  end

  def create_opinions_create_activty(opinion)
    discussion = opinion.discussion
    discussion.create_activity(key: 'opinion',
      task: 'create',
      subject: opinion,
      owner: current_user)
  end

  def destroy_opinions_activty(opinion)
    discussion = opinion.discussion
    activity = discussion.activities.find_by(key: 'opinion', subject: opinion)
    activity.try(:destroy)
  end

  def create_votes_in_favor_activty(vote)
    discussion = vote.proposal.discussion
    discussion.create_activity(key: 'proposal',
      task: 'vote.in_favor',
      subject: vote.proposal,
      measure: vote,
      owner: current_user)
  end

  def create_votes_opposed_activty(vote)
    discussion = vote.proposal.discussion
    discussion.create_activity(key: 'proposal',
      task: 'vote.opposed',
      subject: vote.proposal,
      measure: vote,
      owner: current_user)
  end

  def create_votes_unvote_activty(vote)
    discussion = vote.proposal.discussion
    discussion.create_activity(key: 'proposal',
      task: 'vote.unvote',
      subject: vote.proposal,
      measure: vote,
      owner: current_user)
  end

  def create_porposals_create_activty(proposal)
    discussion = proposal.discussion
    discussion.create_activity(key: 'proposal',
      task: 'create',
      subject: proposal,
      owner: current_user)
  end

  def create_porposals_update_activty(proposal)
    discussion = proposal.discussion
    discussion.create_activity(key: 'proposal',
      task: 'update',
      subject: proposal,
      owner: current_user)
  end

  def create_porposals_destroy_activty(proposal)
    discussion = proposal.discussion
    discussion.create_activity(key: 'proposal',
      task: 'destroy',
      subject: proposal,
      owner: current_user)
  end

  def create_attachments_create_activty(attachment)
    discussion = attachment.discussion
    return if discussion.nil?

    case attachment.attachable_type
    when Discussion.to_s
      discussion.create_activity(key: 'discussion.decision',
      task: 'attachment.create',
      subject: attachment.attachable,
      measure: attachment,
      owner: current_user)
    when Proposal.to_s
      discussion.create_activity(key: 'proposal',
      task: 'attachment.create',
      subject: attachment.attachable,
      measure: attachment,
      owner: current_user)
    else
    end
  end

  def create_attachments_destroy_activty(attachment)
    discussion = attachment.discussion
    return if discussion.nil?

    case attachment.attachable_type
    when Discussion.to_s
      discussion.create_activity(key: 'discussion.decision',
      task: 'attachment.destroy',
      subject: attachment.attachable,
      measure: attachment,
      owner: current_user)
    when Proposal.to_s
      discussion.create_activity(key: 'proposal',
      task: 'attachment.destroy',
      subject: attachment.attachable,
      measure: attachment,
      owner: current_user)
    else
    end
  end

  def grouping_criteria(activity)
    case(activity.key)
    when 'votes.in_favor', 'votes.opposed', 'votes.unvote'
      return activity.recipient_with_deleted.proposal
    when 'discussions.attachments.create', 'discussions.attachments.destroy', 'proposals.attachments.create', 'proposals.attachments.destroy'
      return activity.recipient_with_deleted.attachable
    else
      return activity.recipient_with_deleted
    end
  end
end
