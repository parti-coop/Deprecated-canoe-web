class Api::V1::RequestToJoinsController < Api::V1::BaseController
  include Messaging

  def create
    @canoe = Canoe.find params[:canoe_id]

    check_errors_before_create

    @request_to_join = @canoe.request_to_joins.build
    @request_to_join.user = current_user
    @request_to_join.reason = params[:reason]
    if @request_to_join.save
      notify_to_crews(@request_to_join)
      push_to_client(@request_to_join)
      expose @request_to_join, status: :ok
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
      push_to_client(@request_to_join)
      head :ok
    else
      error!(:invalid_resource, @request_to_join.errors)
    end
  end

  def accept
    @request_to_join = RequestToJoin.find params[:id]
    @canoe = @request_to_join.canoe

    check_errors_before_accept

    @crew = @canoe.crews.find_or_initialize_by(user: @request_to_join.user)
    @crew.host = current_user
    if @crew.save
      notify_to_crews(@request_to_join)
      push_to_client(@request_to_join)
      head :ok
    else
      error!(:invalid_resource, @crew.errors)
    end
  end

  private

  def check_errors_before_create
    refute_crew!
    assert_canoe_to_be_able_to_request_to_join!
    refute_invited!
  end

  def check_errors_before_destory
    assert_crew_or_current_user!(@request_to_join.user)
  end

  def check_errors_before_accept
    assert_crew!
    assert_canoe_to_be_able_to_request_to_join!
  end
end

