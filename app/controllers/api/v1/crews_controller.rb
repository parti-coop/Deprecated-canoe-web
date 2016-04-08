class Api::V1::CrewsController < Api::V1::BaseController
  include Messaging

  def destroy_me
    @canoe = Canoe.find params[:id]

    check_errors_before_destroy_me

    @crew = @canoe.crews.find_by user: current_user
    if @crew.destroy
      notify_to_crews(@crew)
      push_to_client(@crew)
      head :ok
    else
      error!(:invalid_resource, @crew.errors)
    end
  end

  private

  def check_errors_before_destroy_me
    refute_captain!
    assert_crew!
  end

end

