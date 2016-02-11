class RequestToJoinsController < ApplicationController
  include SlackPushing
  include Messaging

  before_filter :authenticate_user!
  load_and_authorize_resource :canoe

  def index
    @request_to_joins = @canoe.request_to_joins
  end

  def ask
    if @canoe.crew?(current_user) or !@canoe.is_able_to_request_to_join? or @canoe.invited?(current_user)
      redirect_to @canoe and return
    end
    @request_to_join = @canoe.request_to_joins.build
    @request_to_join.user = current_user
    if @request_to_join.save
      notify_to_crews(@request_to_join)
      push_to_slack(@request_to_join)
    end
    redirect_to @canoe
  end

  def accept
    redirect_to @canoe and return if !@canoe.is_able_to_request_to_join?
    @request_to_join = RequestToJoin.find(params[:id])
    @crew = @canoe.crews.find_or_initialize_by(user: @request_to_join.user)
    @crew.host = current_user
    if @crew.save
      notify_to_crews(@request_to_join)
      push_to_slack(@request_to_join)
    end
    redirect_to @canoe
  end
end
