class MessagesController < ApplicationController
  before_filter :authenticate_user!
  after_action :mark_as_read, only: :index

  def index
    @all_count = current_user.mailbox.notifications.count
    @notifications = current_user.mailbox.notifications.page params[:page]
  end

  private

  def mark_as_read
    Mailboxer::Receipt.notifications_receipts.recipient(current_user).mark_as_read
  end
end
