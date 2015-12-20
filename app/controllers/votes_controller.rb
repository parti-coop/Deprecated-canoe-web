class VotesController < ApplicationController
  before_filter :authenticate_user!
  before_filter :proposal

  def in_favor
    setup_vote(:in_favor).save
    redirect_to @proposal.discussion
  end

  def opposed
    setup_vote(:opposed).save
    redirect_to @proposal.discussion
  end

  def unvote
    @vote = @proposal.votes.find_by user: current_user
    if @vote.persisted?
      @vote.destroy
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
