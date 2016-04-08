class Api::V1::OpinionsController < Api::V1::BaseController
  after_action :message_for_mentions, only: [:create, :update]

  include Messaging
  include DiscussionActivityTraking

  def create
    @discussion = Discussion.find params[:discussion_id]
    @canoe = @discussion.canoe

    assert_crew!

    @opinion = @discussion.opinions.build(opinion_params)
    @opinion.user = current_user

    @opinion.attachments.each do |attachment|
      attachment.user = current_user
    end
    if @opinion.save
      create_opinions_create_activty @opinion
      push_to_client(@opinion)

      expose @opinion
    else
      error!(:invalid_resource, @opinion.errors)
    end
  end

  def update
    @opinion = Opinion.find params[:id]

    assert_current_user!(@opinion.user)

    if @opinion.update_attributes(opinion_params)
      push_to_client(@opinion)
      expose @opinion
    else
      error!(:invalid_resource, @opinion.errors)
    end
  end

  def destroy
    @opinion = Opinion.find params[:id]

    assert_current_user!(@opinion.user)

    if @opinion.destroy
      destroy_opinions_activty @opinion
      head :ok
    else
      error!(:invalid_resource, @opinion.errors)
    end
  end

  private

  def opinion_params
    params.require(:opinion).permit(:body, attachments_attributes: [ :source ])
  end

  def message_for_mentions
    notify_for_mentions(@opinion.mentions)
  end
end
