class CrewsController < ApplicationController
  include SlackPushing
  include Messaging

  before_filter :authenticate_user!
  load_and_authorize_resource :canoe
  load_and_authorize_resource :crew, through: :canoe, shallow: true

  def destroy
    if @canoe.crew?(current_user) and !@canoe.captain?(current_user)
      @crew = @canoe.crews.find_by user: current_user
      if @crew.try(:destroy)
        notify_to_crews(@crew)
        push_to_slack(@crew)
      end
    end

    redirect_to @canoe
  end

  private

  def create_params
  end

  def fetch_user
    user_key = params[:crew][:user_key]
    @fetch_user ||= User.find_by_key(user_key)
  end

end
