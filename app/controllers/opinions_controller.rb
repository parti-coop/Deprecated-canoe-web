class OpinionsController < ApplicationController
  include SlackNotifing

  before_filter :authenticate_user!, except: [:show]
  load_and_authorize_resource :canoe
  load_and_authorize_resource :discussion, through: :canoe, shallow: true
  load_and_authorize_resource :opinion, through: :discussion, shallow: true

  def show
  end

  def new
  end

  def edit
  end

  def create
    @opinion.user = current_user
    if @opinion.save
      slack(@opinion)
    end
    redirect_to @discussion
  end

  def update
    if @opinion.update_attributes(opinion_params)
      slack(@opinion)
    end
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

  def opinion_params
    params.require(:opinion).permit(:body)
  end
end
