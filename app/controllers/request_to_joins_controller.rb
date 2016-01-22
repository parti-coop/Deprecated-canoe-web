class RequestToJoinsController < ApplicationController
  include SlackNotifing
  include Messaging

  before_filter :authenticate_user!
  load_and_authorize_resource :canoe

  def index
    @request_to_joins = @canoe.request_to_joins
  end

  def ask
    return if @canoe.crew?(current_user)
    @request_to_join = @canoe.request_to_joins.build
    @request_to_join.user = current_user
    if @request_to_join.save
      notify_to_crews(@request_to_join)
      slack(@request_to_join)
    end
    redirect_to @canoe
  end

  def accept
    @request_to_join = RequestToJoin.find(params[:id])
    @crew = @canoe.crews.find_or_initialize_by(user: @request_to_join.user)
    @crew.inviter = current_user
    if @crew.save and @request_to_join.delete
      notify_to_crews(@request_to_join)
      slack(@request_to_join)
    end
    redirect_to @canoe
  end
end
