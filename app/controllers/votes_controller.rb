class VotesController < ApplicationController
  include SlackNotifing

  before_filter :authenticate_user!
  before_filter :proposal

  def in_favor
    @vote = setup_vote(:in_favor)
    @vote.save
    slack(@vote)
    redirect_to @proposal.discussion
  end

  def opposed
    @vote = setup_vote(:opposed)
    @vote.save
    slack(@vote)
    redirect_to @proposal.discussion
  end

  def unvote
    @vote = @proposal.votes.find_by user: current_user
    if @vote.persisted?
      @vote.destroy
      slack(@vote)
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
