class ProposalsController < ApplicationController
  include SlackNotifing

  before_filter :authenticate_user!, except: [:show]
  load_and_authorize_resource :canoe
  load_and_authorize_resource :discussion, through: :canoe, shallow: true
  load_and_authorize_resource :proposal, through: :discussion, shallow: true

  def show
  end

  def new
  end

  def edit
  end

  def create
    @proposal.user = current_user
    if @proposal.save
      slack(@proposal)
    end
    redirect_to @discussion
  end

  def update
    if @proposal.update_attributes(proposal_params)
      slack(@proposal)
    end
    redirect_to @proposal.discussion
  end

  def destroy
    @proposal.destroy
    slack(@proposal)
    redirect_to @proposal.discussion
  end

  private

  def proposal_params
    params.require(:proposal).permit(:body)
  end
end
