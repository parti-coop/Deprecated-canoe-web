class DiscussionsController < ApplicationController
  include SlackNotifing
  include Messaging

  before_filter :authenticate_user!, except: [:show]
  load_and_authorize_resource :canoe
  load_and_authorize_resource :discussion, through: :canoe, shallow: true

  def index
    @discussions_limited = current_user.crewing_discussions.order(discussed_at: :desc).first(10)
  end

  def show
    if user_signed_in?
      @discussion.mark_as_read! :for => current_user
    end
    @canoe = @discussion.canoe
  end

  def new
  end

  def edit
  end

  def create
    @discussion.user = current_user
    if @discussion.save
      notify_to_crews(@discussion)
      slack(@discussion)
      redirect_to @discussion
    else
      render 'new'
    end
  end

  def update
    if @discussion.update_attributes(update_params)
      slack(@discussion)
      redirect_to @discussion
    else
      render 'edit'
    end
  end

  def destroy
    @discussion.destroy
    notify_to_crews(@discussion)
    slack(@discussion)
    redirect_to @discussion.canoe
  end

  private

  def create_params
    params.require(:discussion).permit(:subject, :body, :canoe_id)
  end

  def update_params
    params.require(:discussion).permit(:subject, :body, :decision)
  end
end
