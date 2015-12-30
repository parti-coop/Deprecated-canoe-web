class DiscussionsController < ApplicationController
  include SlackNotifing

  before_filter :authenticate_user!, except: [:show]
  before_filter :fetch_discussion, only: [:show, :edit, :update, :destroy]
  before_filter :correct_crew, only: [:edit, :update]
  before_filter :correct_owner, only: [:destroy]

  def show
    @pinned_opinions = @discussion.opinions.pinned
  end

  def new
    @canoe = Canoe.find params[:canoe_id]
    @discussion = @canoe.discussions.build
  end

  def edit
  end

  def create
    @canoe = Canoe.find params[:canoe_id]

    unless @canoe.crew?(current_user)
      redirect_to(@canoe) and return
    end

    @discussion = @canoe.discussions.new create_param
    @discussion.user = current_user
    if @discussion.save
      slack(@discussion)
      redirect_to @discussion
    else
      render 'new'
    end
  end

  def update
    @discussion.update(update_param)
    slack(@discussion)
    redirect_to @discussion
  end

  def destroy
    @discussion.destroy
    slack(@discussion)
    redirect_to @discussion.canoe
  end

  private

  def create_param
    params.require(:discussion).permit(:subject, :body)
  end

  def update_param
    params.require(:discussion).permit(:subject, :body, :decision)
  end

  def fetch_discussion
    @discussion ||= Discussion.find params[:id]
  end

  def correct_crew
    unless fetch_discussion.canoe.crew?(current_user)
      redirect_to(@discussion)
    end
  end

  def correct_owner
    unless fetch_discussion.user == current_user
      redirect_to(@discussion)
    end
  end
end

