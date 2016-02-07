class VotesController < ApplicationController
  include SlackPushing
  include DiscussionActivityTraking

  before_filter :authenticate_user!
  before_filter :proposal

  def in_favor
    @vote = setup_vote(:in_favor)
    if(@vote.save)
      push_to_slack(@vote)
      create_votes_in_favor_activty(@vote)
    end
    redirect_to @proposal.discussion
  end

  def opposed
    @vote = setup_vote(:opposed)
    if(@vote.save)
      push_to_slack(@vote)
      create_votes_opposed_activty(@vote)
    end
    redirect_to @proposal.discussion
  end

  def unvote
    @vote = @proposal.votes.find_by user: current_user
    if @vote.present? and @vote.destroy
      push_to_slack(@vote)
      create_votes_unvote_activty(@vote)
    end
    redirect_to @proposal.discussion
  end

  private

  def proposal
    @proposal ||= Proposal.find params[:id]
  end

  def setup_vote(choice)
    @vote = proposal.votes.find_or_initialize_by(user: current_user)
    @vote.assign_attributes(choice: choice)
    @vote
  end
end
