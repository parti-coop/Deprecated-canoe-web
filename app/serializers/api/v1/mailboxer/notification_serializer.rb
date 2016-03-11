class Api::V1::Mailboxer::NotificationSerializer < ActiveModel::Serializer
  attributes(*(Mailboxer::Notification.attribute_names.map(&:to_sym) << :is_read))

  cattr_accessor :serializer_params
  def initialize(serializer, object)
    super
    @serializer_params = object[:serializer_params]
  end

  def is_read
    object.is_read?(@serializer_params[:current_user])
  end
end
