class RequestToJoinsController < ApplicationController
  before_filter :authenticate_user!
  load_and_authorize_resource :canoe

  def index
    @request_to_joins = @canoe.request_to_joins
  end

  def ask
    return if @canoe.crew?(current_user)
    @request_to_join = @canoe.request_to_joins.build
    @request_to_join.user = current_user
    @request_to_join.save
    redirect_to @canoe
  end

  def accept
    @request_to_join = RequestToJoin.find(params[:id])
    @crew = @canoe.crews.find_or_initialize_by(user: @request_to_join.user)
    @crew.inviter = current_user
    @crew.save and @request_to_join.delete
    redirect_to @canoe
  end
end
