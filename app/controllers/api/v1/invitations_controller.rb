class Api::V1::InvitationsController < Api::V1::BaseController
  include Messaging

  def create
    @canoe = Canoe.find params[:canoe_id]

    assert_crew!

    @invitation = @canoe.invitations.build(create_params)
    @invitation.user = User.find_by_key(@invitation.user_key)

    if @invitation.user.present?
      refute_crew_of!(@invitation.user)
      @crew = @invitation.canoe.crews.build(
        user: @invitation.user,
        host: current_user)

      if @crew.save
        notify_to_crews(@invitation)
        push_to_client(@invitation)
      end
      head :ok
    elsif @invitation.user_key =~ /@/
      @previous_invitation = Invitation.where(email: @invitation.user_key)
      @invitation.email = @invitation.user_key
      @invitation.host = current_user
      if @invitation.save
        notify_to_crews(@invitation)
        push_to_client(@invitation)
      end
      head :ok
    else
      head :not_found
    end
  end

  def destroy
    @invitation = Invitation.find params[:id]
    @canoe = @invitation.canoe

    assert_crew!

    if @invitation.destroy
      notify_to_crews(@invitation)
      push_to_client(@invitation)
      head :ok
    else
      error!(:invalid_resource, @invitation.errors)
    end
  end

  private

  def create_params
    params.require(:invitation).permit(:user_key)
  end
end

