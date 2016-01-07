class DiscussionsController < ApplicationController
  include SlackNotifing

  before_filter :authenticate_user!, except: [:index, :show]
  load_and_authorize_resource :canoe
  load_and_authorize_resource :discussion, through: :canoe, shallow: true

  def index
    @discussions = Discussion.joins(:canoe).order(discussed_at: :desc)
  end

  def show
    @pinned_opinions = @discussion.opinions.pinned
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
    params.require(:discussion).permit(:subject, :body)
  end

  def update_params
    params.require(:discussion).permit(:subject, :body, :decision)
  end
end
