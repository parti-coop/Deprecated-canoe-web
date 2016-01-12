class DiscussionsController < ApplicationController
  include SlackNotifing

  before_filter :authenticate_user!, except: [:show]
  load_and_authorize_resource :canoe
  load_and_authorize_resource :discussion, through: :canoe, shallow: true

  def index
    @unread_discussions_all = current_user.crewing_discussions.unread
    @unread_discussions_limited = @unread_discussions_all.order(discussed_at: :desc).first(5)
    @read_discussions_limited = current_user.crewing_discussions.read.order(discussed_at: :desc).first(5)
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
