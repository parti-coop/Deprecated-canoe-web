class ProposalsController < ApplicationController
  include SlackNotifing
  include DiscussionActivityTraking

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
      create_porposals_create_activty(@proposal)
      slack(@proposal)
    end
    redirect_to @discussion
  end

  def update
    if @proposal.update_attributes(proposal_params)
      slack(@proposal)
      create_porposals_update_activty(@proposal)
    end
    redirect_to @proposal.discussion
  end

  def destroy
    if @proposal.destroy
      create_porposals_destroy_activty(@proposal)
      slack(@proposal)
    end
    redirect_to @proposal.discussion
  end

  private

  def proposal_params
    params.require(:proposal).permit(:body)
  end
end
