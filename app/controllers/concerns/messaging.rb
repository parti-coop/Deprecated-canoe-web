require 'erb'

module Messaging
  extend ActiveSupport::Concern

  def notify_for_mentions(mentions)
    return unless user_signed_in?

    mentions.each do |mention|
      not_used, body_for_the_concerned = render_bodies(mention)
      Mailboxer::Notification.notify_all(mention.user, "#{controller_name}##{action_name}", body_for_the_concerned, mention)
    end
  end

  def notify_to_crews(object)
    return unless user_signed_in?

    body, body_for_the_concerned = render_bodies(object)
    recipients, the_concerned = fetch_recipients(object)

    if recipients.present? and body.present?
      Mailboxer::Notification.notify_all(recipients, "#{controller_name}##{action_name}", body, object)
    end
    if the_concerned.present? and body_for_the_concerned.present?
      Mailboxer::Notification.notify_all(the_concerned, "#{controller_name}##{action_name}", body_for_the_concerned, object)
    end
  end

  private

  BODY_TEMPLATE = {
    canoes: {
      destroy: "@<%= current_user.nickname %>님이 '<%= object.title %>' 카누를 지웠습니다."
    },
    discussions: {
      destroy: "@<%= current_user.nickname %>님이 '<%= link_to_canoe_title(object.canoe) %>' 카누의 '<%= object.subject %>'논의를 지웠습니다."
    },
    request_to_joins: {
      ask: "@<%= current_user.nickname %>님이 '<%= link_to_canoe_title(object.canoe) %>' 카누에 가입요청을 했습니다.",
      accept: "@<%= current_user.nickname %>님이 '<%= link_to_canoe_title(object.canoe) %>' 카누에 @<%= object.user.nickname %>의 가입요청을 수락했습니다."
    },
    invitations: {
      create: "@<%= current_user.nickname %>님이 '<%= link_to_canoe_title(object.canoe) %>' 카누에 <%= object.guest_name %>님을 초대했습니다.",
      destroy: "@<%= current_user.nickname %>님이 '<%= link_to_canoe_title(object.canoe) %>' 카누에 <%= object.guest_name %>님의 초대를 취소했습니다.",
      accept: "@<%= current_user.nickname %>님이 '<%= link_to_canoe_title(object.canoe) %>' 카누 초대를 승락했습니다.",
    },
    crews: {
      destroy: "@<%= current_user.nickname %>님이 '<%= link_to_canoe_title(object.canoe) %>' 카누에서 탈퇴했습니다.",
    }
  }
  BODY_TEMPLATE_FOR_THE_CONCERNED = {
    request_to_joins: {
      accept: "'<%= link_to_canoe_title(object.canoe) %>' 카누 가입요청을 @<%= current_user.nickname %>님이 수락해 주었습니다."
    },
    invitations: {
      create: "'<%= link_to_canoe_title(object.canoe) %>' 카누에 초대받았습니다.",
      destroy: "'<%= link_to_canoe_title(object.canoe) %>' 카누에 초대가 취소되었습니다.",
    },
    opinions: {
      create: "'<%= link_to_canoe_title(object.opinion.canoe) %>' 카누 '<%= link_to_discussion_subject object.opinion.discussion %>'논의에서 @<%= current_user.nickname %>님이 아래 의견을 올렸습니다.\n<blockquote class='message-box message-box__mention'><%= view_context.truncate(object.opinion.body) %></blockquote>",
      update: "'<%= link_to_canoe_title(object.opinion.canoe) %>' 카누 '<%= link_to_discussion_subject object.opinion.discussion %>'논의에서 @<%= current_user.nickname %>님이 아래 의견을 올렸습니다.\n<blockquote class='message-box message-box__mention'><%= view_context.truncate(object.opinion.body) %></blockquote>"
    }
  }

  def render_bodies(object)
    body = render_body(object, BODY_TEMPLATE)
    body_for_the_concern = render_body(object, BODY_TEMPLATE_FOR_THE_CONCERNED) || body
    [body, body_for_the_concern]
  end

  def render_body(object, template_map)
    template = template_map.dig(controller_name.to_sym, action_name.to_sym)
    return if template.blank?

    ERB.new(template).result(binding)
  end

  def fetch_recipients(object)
    canoe = object if object.class == Canoe
    canoe ||= object.discussion.canoe if object.respond_to?(:discussion)
    canoe ||= object.canoe if object.respond_to?(:canoe)
    return if canoe.nil?

    the_concerned = object.the_concerned_for_messaging if object.respond_to?(:the_concerned_for_messaging)
    the_concerned = nil if the_concerned == current_user
    recipients = canoe.crews.where.not(user: [current_user, the_concerned]).map(&:user)

    [recipients, the_concerned]
  end

  def link_to_canoe_title(canoe)
    view_context.link_to(canoe.title, view_context.canoe_home_path(canoe))
  end

  def link_to_discussion_subject(discussion)
    view_context.content_tag('span', discussion.sequential_id, class: %w(label label-default)) + view_context.link_to(discussion.subject, view_context.discussion_home_path(discussion))
  end
end
