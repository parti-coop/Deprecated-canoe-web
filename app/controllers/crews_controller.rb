class CrewsController < ApplicationController
  include SlackNotifing
  include Messaging
  before_filter :authenticate_user!

  def destory
    @canoe = Canoe.find params[:canoe_id]
    if @canoe.crew?(current_user) and !@canoe.captain?(current_user)
      @crew = @canoe.crews.find_by user: current_user
      if @crew.try(:destroy)
        notify_to_crews(@crew)
        slack(@crew)
      end
    end

    redirect_to @canoe
  end
end
