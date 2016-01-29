class MessagesController < ApplicationController
  before_filter :authenticate_user!

  def index
    @unread_count = current_user.mailbox.notifications.unread.count
    @notifications = current_user.mailbox.notifications.page params[:page]
  end

  def mark_as_read
    mark_as(:read)
  end

  def mark_as_unread
    mark_as(:unread)
  end

  def mark_as(read_or_unread)
    @notification = current_user.mailbox.notifications.find params[:id]
    if read_or_unread == :read
      @notification.mark_as_read(current_user)
    else
      @notification.mark_as_unread(current_user)
    end
    respond_to do |format|
      format.html { redirect_to :index }
      format.js { render(template: "messages/mark_as") }
    end
  end
end
