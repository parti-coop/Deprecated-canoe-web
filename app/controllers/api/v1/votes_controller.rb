class Api::V1::VotesController < Api::V1::BaseController
  before_filter :proposal
  include DiscussionActivityTraking

  def in_favor
    @canoe = proposal.canoe
    assert_crew!

    @vote = setup_vote(:in_favor)
    if @vote.save
      @vote.proposal.reload

      push_to_client(@vote)
      create_votes_in_favor_activty(@vote)

      expose @vote, include: { proposal: {} }
    else
      error!(:invalid_resource, @vote.errors)
    end
  end

  def opposed
    @canoe = proposal.canoe
    assert_crew!

    @vote = setup_vote(:opposed)
    if @vote.save
      @vote.proposal.reload

      push_to_client(@vote)
      create_votes_opposed_activty(@vote)
      expose @vote, include: { proposal: {} }
    else
      error!(:invalid_resource, @vote.errors)
    end
  end

  def unvote
    @vote = proposal.votes.find_by user: current_user
    if @vote.present? and @vote.destroy
      push_to_client(@vote)
      create_votes_unvote_activty(@vote)
      head :ok
    else
      error!(:invalid_resource, @vote.errors)
    end
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
