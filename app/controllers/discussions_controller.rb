class DiscussionsController < ApplicationController
  include SlackNotifing

  before_filter :authenticate_user!, except: [:show]
  before_filter :fetch_discussion, only: [:show, :edit, :update, :destroy]
  before_filter :correct_user, only: [:edit, :update, :destroy]

  def show
  end

  def new
    @canoe = Canoe.find params[:canoe_id]
    @discussion = @canoe.discussions.build
  end

  def edit
  end

  def create
    @canoe = Canoe.find params[:canoe_id]
    @discussion = @canoe.discussions.new discussion_param
    @discussion.user = current_user
    if @discussion.save
      slack(@discussion)
      redirect_to @discussion
    else
      render 'new'
    end
  end

  def update
    @discussion.update(discussion_param)
    slack(@discussion)
    redirect_to @discussion
  end

  def destroy
    @discussion.destroy
    slack(@discussion)
    redirect_to @discussion.canoe
  end

  private

  def discussion_param
    params.require(:discussion).permit(:subject, :body)
  end

  def fetch_discussion
    @discussion ||= Discussion.find params[:id]
  end

  def correct_user
    unless fetch_discussion.user == current_user
      redirect_to(@discussion)
    end
  end
end

