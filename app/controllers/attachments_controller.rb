class AttachmentsController < ApplicationController
  before_filter :authenticate_user!
  load_and_authorize_resource :canoe
  load_and_authorize_resource :discussion, through: :canoe, shallow: true
  load_and_authorize_resource :attachment, through: :discussion, shallow: true

  def create
    @attachment.user = current_user
    @attachment.save

    redirect_to @attachment.discussion
  end

  def destroy
    @attachment.destroy

    redirect_to @attachment.discussion
  end
  private

  def create_params
    params.require(:attachment).permit(:file)
  end
end
