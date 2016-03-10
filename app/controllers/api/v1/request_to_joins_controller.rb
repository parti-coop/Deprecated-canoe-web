class Api::V1::RequestToJoinsController < Api::V1::BaseController
  include SlackPushing
  include Messaging

  def create
    @canoe = Canoe.find params[:canoe_id]

    check_errors_before_create

    @request_to_join = @canoe.request_to_joins.build
    @request_to_join.user = current_user
    @request_to_join.reason = params[:reason]
    if @request_to_join.save
      notify_to_crews(@request_to_join)
      push_to_slack(@request_to_join)
      expose @request_to_join, status: :created
    else
      error!(:invalid_resource, @request_to_join.errors)
    end
  end

  def destroy
    @request_to_join = RequestToJoin.find params[:id]
    @canoe = @request_to_join.canoe

    check_errors_before_destory

    if @request_to_join.destroy
      notify_to_crews(@request_to_join)
      push_to_slack(@request_to_join)
      head :no_content
    else
      error!(:invalid_resource, @request_to_join.errors)
    end
  end

  private

  def check_errors_before_create
    if @canoe.crew?(current_user)
      error! :conflict, 'already crew'
    end
    if !@canoe.is_able_to_request_to_join?
      error! :conflict, 'this canoe was prohibited to request to join'
    end
    if @canoe.invited?(current_user)
      error! :conflict, 'already invited'
    end
  end

  def check_errors_before_destory
    if !@canoe.crew?(current_user) and @request_to_join.user != current_user
      error! :forbidden
    end
  end
end

