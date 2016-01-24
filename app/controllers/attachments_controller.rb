class AttachmentsController < ApplicationController
  include DiscussionActivityTraking

  before_filter :authenticate_user!
  load_and_authorize_resource :attachment

  def create
    @attachment.user = current_user
    if @attachment.save
      create_attachments_create_activty(@attachment)
    end

    @discussion = @attachment.discussion
    if @discussion.present?
      redirect_to @discussion
    else
      redirect_to root_path
    end
  end

  def destroy
    if @attachment.destroy
      create_attachments_destroy_activty(@attachment)
    end

    @discussion = @attachment.discussion
    if @discussion.present?
      redirect_to @discussion
    else
      redirect_to root_path
    end
  end

  private

  def create_params
    params.require(:attachment).permit(:source, :attachable_id, :attachable_type)
  end
end
