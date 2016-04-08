class Api::V1::ProposalsController < Api::V1::BaseController
  include DiscussionActivityTraking

  def create
    @discussion = Discussion.find params[:discussion_id]
    @canoe = @discussion.canoe

    assert_crew!

    @proposal = @discussion.proposals.build(proposal_params)
    @proposal.user = current_user
    @proposal.attachments.each do |attachment|
      attachment.user = current_user
    end
    if @proposal.save
      create_porposals_create_activty(@proposal)
      push_to_client(@proposal)
      expose @proposal
    else
      error!(:invalid_resource, @proposal.errors)
    end
  end

  def update
    @proposal = Proposal.find params[:id]

    assert_current_user!(@proposal.user)

    if @proposal.update_attributes(proposal_params)
      push_to_client(@proposal)
      expose @proposal
    else
      error!(:invalid_resource, @proposal.errors)
    end
  end

  def destroy
    @proposal = Proposal.find params[:id]

    assert_current_user!(@proposal.user)

    if @proposal.destroy
      create_porposals_destroy_activty @proposal
      head :ok
    else
      error!(:invalid_resource, @proposal.errors)
    end
  end

  private

  def proposal_params
    params.require(:proposal).permit(:body, attachments_attributes: [ :source ])
  end
end
