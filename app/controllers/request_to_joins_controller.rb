class RequestToJoinsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :fetch_canoe

  def ask
    redirect_to @canoe and return unless correct_visitor

    @request_to_join = @canoe.request_to_joins.build
    @request_to_join.user = current_user
    @request_to_join.save
    redirect_to @canoe
  end

  def accept
    redirect_to @canoe and return unless correct_crew

    @request_to_join = RequestToJoin.find(params[:id])
    @crew = @canoe.crews.build
    @crew.user = @request_to_join.user
    @crew.inviter = current_user
    @crew.save and @request_to_join.delete
    redirect_to @canoe
  end

  private

  def fetch_canoe
    @canoe ||= Canoe.find params[:canoe_id]
  end

  def correct_crew
    fetch_canoe.crew? current_user
  end

  def correct_visitor
    !fetch_canoe.crew?(current_user) and !fetch_canoe.request_to_join?(current_user)
  end
end
