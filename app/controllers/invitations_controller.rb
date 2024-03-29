class InvitationsController < ApplicationController
  include SlackPushing
  include Messaging

  before_filter :authenticate_user!
  load_and_authorize_resource :canoe
  load_and_authorize_resource :invitation, through: :canoe, shallow: true, except: :accept

  def create
    @invitation.user ||= User.find_by_key(@invitation.user_key)
    if @invitation.user.present?
      @crew = @invitation.canoe.crews.build(
        user: @invitation.user,
        host: current_user)

      if @crew.save
        notify_to_crews(@invitation)
        push_to_slack(@invitation)
      end

      redirect_to view_context.canoe_home_path(@invitation.canoe, anchor: 'crews')
    else
      @invitation.email ||= @invitation.user.email if @invitation.user.present?
      @invitation.email ||= @invitation.user_key if @invitation.user_key =~ /@/
      @invitation.host = current_user
      if invitable? && @invitation.save
        notify_to_crews(@invitation)
        push_to_slack(@invitation)
      end

      redirect_to canoe_invitations_path(@canoe)
    end
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
      host: @invitation.host)

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

  def invitable?
    return true if @invitation.user.blank?
    return false if @canoe.crew?(@invitation.user)
    return false if @canoe.request_to_join?(@invitation.user)

    true
  end

  def create_params
    params.require(:invitation).permit(:user_key)
  end
end
