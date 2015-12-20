class OpinionsController < ApplicationController
  before_filter :authenticate_user!, except: [:show]
  before_filter :fetch_opinion, only: [:show, :edit, :update, :destroy]
  before_filter :correct_user, only: [:edit, :update, :destroy]

  def show
  end

  def new
    @discussion = Discussion.find params[:discussion_id]
    @opinion = @discussion.opinions.build
  end

  def edit
  end

  def create
    @discussion = Discussion.find params[:discussion_id]
    @opinion = @discussion.opinions.new opinion_param
    @opinion.user = current_user
    if @opinion.save
      redirect_to @discussion
    else
      render 'new'
    end
  end

  def update
    @opinion.update(opinion_param)
    redirect_to @opinion.discussion
  end

  def destroy
    @opinion.destroy
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
