class OpinionsController < ApplicationController
  include SlackNotifing

  before_filter :authenticate_user!, except: [:show]
  before_filter :fetch_opinion, only: [:show, :edit, :update, :pin, :unpin, :destroy]
  before_filter :correct_user, only: [:edit, :update, :destroy]

  def show
    @discussion = @opinion.discussion
    @canoe = @discussion.canoe
  end

  def new
    @discussion = Discussion.find params[:discussion_id]
    @opinion = @discussion.opinions.build
  end

  def edit
  end

  def create
    @discussion = Discussion.find params[:discussion_id]

    unless @discussion.canoe.crew?(current_user)
      redirect_to(@discussion.canoe) and return
    end

    @opinion = @discussion.opinions.new opinion_param
    @opinion.user = current_user
    if @opinion.save
      slack(@opinion)
      redirect_to @discussion
    else
      render 'new'
    end
  end

  def update
    @opinion.update(opinion_param)
    slack(@opinion)
    redirect_to @opinion.discussion
  end

  def destroy
    @opinion.destroy
    slack(@opinion)
    redirect_to @opinion.discussion
  end

  def pin
    @opinion.update_attributes(pinned: true, pinned_at: DateTime.now)
    redirect_to @opinion.discussion
  end

  def unpin
    @opinion.update_attributes(pinned: false, pinned_at: nil)
    redirect_to @opinion.discussion
  end

  private

  def opinion_param
    params.require(:opinion).permit(:body)
  end

  def fetch_opinion
    @opinion ||= Opinion.find params[:id]
  end

  def correct_user
    unless fetch_opinion.user == current_user
      redirect_to(@opinion.discussion)
    end
  end
end
