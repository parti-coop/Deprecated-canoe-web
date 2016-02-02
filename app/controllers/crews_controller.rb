class CrewsController < ApplicationController
  include SlackNotifing
  include Messaging

  before_filter :authenticate_user!
  load_and_authorize_resource :canoe
  load_and_authorize_resource :crew, through: :canoe, shallow: true

  def new
  end

  def create
    redirect_to @canoe and return if @canoe.crew?(fetch_user) or @canoe.public_join?

    @crew.user = fetch_user
    @crew.inviter = current_user
    if @crew.user.present? and @crew.save
      redirect_to @canoe
    else
      render 'new'
    end
  end

  def destory
    if @canoe.crew?(current_user) and !@canoe.captain?(current_user)
      @crew = @canoe.crews.find_by user: current_user
      if @crew.try(:destroy)
        notify_to_crews(@crew)
        slack(@crew)
      end
    end

    redirect_to @canoe
  end

  private

  def create_params
  end

  def fetch_user
    user_key = params[:crew][:user_key]
    @fetch_user ||= User.find_or_sync(user_key)
  end

end
