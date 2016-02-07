class InvitationsController < ApplicationController
  include SlackPushing
  include Messaging

  before_filter :authenticate_user!
  load_and_authorize_resource :canoe
  load_and_authorize_resource :invitation, through: :canoe, shallow: true, except: :accept

  def create
    @invitation.user ||= User.find_or_sync(@invitation.user_key)
    @invitation.email ||= @invitation.user.email if @invitation.user.present?
    @invitation.email ||= @invitation.user_key if @invitation.user_key =~ /@/
    @invitation.host = current_user

    unless (@canoe.crew?(@invitation.user) or @canoe.request_to_join?(@invitation.user))
      if @invitation.save
        notify_to_crews(@invitation)
        push_to_slack(@invitation)
      end
    end

    redirect_to canoe_invitations_path(@canoe)
  end

  def destroy
    if @invitation.destroy
      notify_to_crews(@invitation)
      push_to_slack(@invitation)
    end
    redirect_to canoe_invitations_path(@invitation.canoe)
  end

  def accept
    @cano = Canoe.find params[:canoe_id]
    @invitation = @canoe.invitations.of_guest(current_user).first
    @crew = @invitation.canoe.crews.build(
      user: @invitation.user,
      inviter: @invitation.host)

    if @crew.save
      notify_to_crews(@invitation)
      push_to_slack(@invitation)
      current_user.mailbox.notifications.where(notified_object: @invitation).each do |notification|
        notification.mark_as_read(current_user)
      end
    end

    redirect_to @invitation.canoe
  end

  private

  def create_params
    params.require(:invitation).permit(:user_key)
  end
end
