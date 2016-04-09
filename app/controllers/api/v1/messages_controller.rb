class Api::V1::MessagesController < Api::V1::BaseController
  def index
    paginated current_user.mailbox.notifications.page(params[:page]).map{ |n| hashed_notification(n) }
  end

  def unreads_count
    expose current_user.mailbox.notifications.unread.count
  end

  def mark_as_read
    mark_as(:read)
  end

  def mark_as_unread
    mark_as(:unread)
  end

  def mark_all_as_read
    Mailboxer::Receipt.notifications_receipts.recipient(current_user).mark_as_read
    head :ok
  end

  private

  def mark_as(read_or_unread)
    @notification = current_user.mailbox.notifications.find params[:id]
    if read_or_unread == :read
      @notification.mark_as_read(current_user)
    else
      @notification.mark_as_unread(current_user)
    end
    expose hashed_notification(@notification)
  end

  def hashed_notification(notification)
    notification.serializable_hash.update(is_read: notification.is_read?(current_user))
  end
end
