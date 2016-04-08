class Api::V1::DiscussionsController < Api::V1::BaseController
  include DiscussionActivityTraking

  def create
    @canoe = Canoe.find params[:canoe_id]

    assert_crew!

    @discussion = @canoe.discussions.build(create_params)
    @discussion.user = current_user
    @discussion.current_activity_user = current_user

    @opinion = @discussion.opinions.first
    if @opinion.present?
      if @opinion.body.blank?
        @discussion.opinions.destroy @opinion
      else
        @opinion.user = current_user
      end
    end
    if @discussion.save
      push_to_client(@discussion)
      create_opinions_create_activty(@discussion.opinions.first) if @discussion.opinions.first.present?
      expose @discussion
    else
      error!(:invalid_resource, @discussion.errors)
    end
  end

  def show
    @discussion = Discussion.find params[:id]
    @canoe = @discussion.canoe

    assert_canoe!

    if user_signed_in?
      @discussion.mark_as_read! :for => current_user
    end

    expose hashed_detail_discussion(@discussion)
  end

  def decision_histories
    @discussion = Discussion.find params[:id]
    @canoe = @discussion.canoe

    assert_canoe!

    collection @discussion.activities.where('key': 'discussion.decision').order(created_at: :desc).select { |p| p.parameters.present? }, include: [:owner]
  end

  def update
    @discussion = Discussion.find params[:id]
    @canoe = @discussion.canoe

    assert_crew!

    @discussion.current_activity_user = current_user

    if @discussion.update_attributes(update_params)
      push_to_client(@discussion)
      create_discussions_update_decision_activty(@discussion) if @discussion.previous_changes['decision'].present?
      expose @discussion
    else
      error!(:invalid_resource, @discussion.errors)
    end
  end

  private

  def create_params
    params.require(:discussion).permit(:subject, opinions_attributes: [ :body ])
  end

  def update_params
    params.require(:discussion).permit(:decision)
  end
end
