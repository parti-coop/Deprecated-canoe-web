class RequestToJoinsController < ApplicationController
  include SlackNotifing
  include Messaging

  before_filter :authenticate_user!
  load_and_authorize_resource :canoe

  def index
    @request_to_joins = @canoe.request_to_joins
  end

  def ask
    if @canoe.crew?(current_user) or @canoe.private_join? or @canoe.invited?(current_user)
      redirect_to @canoe and return
    end
    @request_to_join = @canoe.request_to_joins.build
    @request_to_join.user = current_user
    if @request_to_join.save
      notify_to_crews(@request_to_join)
      slack(@request_to_join)
    end
    redirect_to @canoe
  end

  def accept
    redirect_to @canoe and return if @canoe.private_join?
    @request_to_join = RequestToJoin.find(params[:id])
    @crew = @canoe.crews.find_or_initialize_by(user: @request_to_join.user)
    @crew.inviter = current_user
    if @crew.save
      notify_to_crews(@request_to_join)
      slack(@request_to_join)
    end
    redirect_to @canoe
  end
end
