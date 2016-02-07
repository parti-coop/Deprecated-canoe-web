class OpinionsController < ApplicationController
  include SlackPushing
  include Messaging
  include DiscussionActivityTraking

  before_filter :authenticate_user!
  after_action :message_for_mentions, only: [:create, :update]
  load_and_authorize_resource :canoe
  load_and_authorize_resource :discussion, through: :canoe, shallow: true
  load_and_authorize_resource :opinion, through: :discussion, shallow: true

  def new
  end

  def edit
  end

  def create
    @opinion.user = current_user
    @opinion.attachments.each do |attachment|
      attachment.user = current_user
    end
    if @opinion.save
      create_opinions_create_activty @opinion
      push_to_slack(@opinion)
    end
    redirect_to @discussion
  end

  def update
    if @opinion.update_attributes(opinion_params)
      push_to_slack(@opinion)
    end
    redirect_to @opinion.discussion
  end

  def destroy
    if @opinion.destroy
      destroy_opinions_activty @opinion
      push_to_slack(@opinion)
    end
    redirect_to @opinion.discussion
  end

  private

  def opinion_params
    params.require(:opinion).permit(:body, attachments_attributes: [ :source ])
  end

  def message_for_mentions
    notify_for_mentions(@opinion.mentions)
  end
end
