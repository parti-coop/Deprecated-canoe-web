class ProposalsController < ApplicationController
  before_filter :authenticate_user!, except: [:show]
  before_filter :fetch_proposal, only: [:show, :edit, :update, :destroy]
  before_filter :correct_user, only: [:edit, :update, :destroy]

  def show
  end

  def new
    @discussion = Discussion.find params[:discussion_id]
    @proposal = @discussion.proposals.build
  end

  def edit
  end

  def create
    @discussion = Discussion.find params[:discussion_id]
    @proposal = @discussion.proposals.new proposal_param
    @proposal.user = current_user
    if @proposal.save
      redirect_to @discussion
    else
      render 'new'
    end
  end

  def update
    @proposal.update(proposal_param)
    redirect_to @proposal.discussion
  end

  def destroy
    @proposal.destroy
    redirect_to @proposal.discussion
  end

  private

  def proposal_param
    params.require(:proposal).permit(:body)
  end

  def fetch_proposal
    @proposal ||= Proposal.find params[:id]
  end

  def correct_user
    unless fetch_proposal.user == current_user
      redirect_to(@proposal.discussion)
    end
  end
end
