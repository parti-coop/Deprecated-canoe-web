# TEST web hook url : "https://hooks.slack.com/services/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"

module SlackNotifing
  extend ActiveSupport::Concern

  def slack(object)
    return if ApplicationController::skip_slack

    @webhook_url = fetch_webhook_url(object)
    return if @webhook_url.blank?

    notifier = Slack::Notifier.new(@webhook_url, username: 'parti-canoe')

    message = make_message(object)
    if message.present?
      notifier.ping("Canoe! Canoe!", attachments: [{ text: message, color: "#36a64f" }])
    end
  end

  private

  def fetch_webhook_url(object)
    canoe = object if object.class == Canoe
    canoe ||= object.discussion.canoe if object.respond_to?(:discussion)
    canoe ||= object.canoe if object.respond_to?(:canoe)

    canoe.try(:slack_webhook_url)
  end

  def make_message(object)
    return unless user_signed_in?

    case "#{controller_name}##{action_name}"
    when "canoes#create"
      canoe = object

      return <<EOF
카누 "#{canoe.title}"
@#{current_user.nickname}님이 카누를 만들었습니다.
#{canoe.theme} >>> [보기](#{canoe_url canoe})
EOF
    when "canoes#update"
      canoe = object

      return <<EOF
카누 "#{canoe.title}"
@#{current_user.nickname}님이 카누를 고쳤습니다.
#{canoe.theme} >>> [보기](#{canoe_url canoe})
EOF
    when "canoes#destroy"
      canoe = object

      return <<EOF
카누 "#{canoe.title}"
#{current_user.nickname}님이 카누를 지웠습니다.
#{canoe.theme} >>> [보기](#{root_url})
EOF
    when "discussions#create"
      discussion = object

      return <<EOF
논의 "#{discussion.subject}"
@#{current_user.nickname}님이 논의를 만들었습니다.
#{discussion.body} >>> [보기](#{discussion_url discussion})
EOF
    when "discussions#update"
      discussion = object

      return <<EOF
논의 "#{discussion.subject}"
@#{current_user.nickname}님이 논의를 고쳤습니다.
#{discussion.body} >>> [보기](#{discussion_url discussion})
EOF
    when "discussions#destroy"
      discussion = object

      return <<EOF
논의 "#{discussion.subject}"
@#{current_user.nickname}님이 논의를 지웠습니다.
#{discussion.body} >>> [보기](#{canoe_url discussion.canoe})
EOF
    when "proposals#create"
      proposal = object
      discussion = proposal.discussion

      return <<EOF
논의 "#{discussion.subject}"
@#{current_user.nickname}님이 "#{proposal.body}"이란 제안을 만들었습니다.
#{proposal.body} >>> [보기](#{discussion_url discussion})
EOF
    when "proposals#update"
      proposal = object
      discussion = proposal.discussion

      return <<EOF
논의 "#{discussion.subject}"
@#{current_user.nickname}님이 "#{proposal.body}"이란 제안을 고쳤습니다.
#{proposal.body} >>> [보기](#{discussion_url discussion})
EOF
    when "proposals#destroy"
      proposal = object
      discussion = proposal.discussion

      return <<EOF
논의 "#{discussion.subject}"
@#{current_user.nickname}님이 "#{proposal.body}"이란 제안을 지웠습니다.
>>> [보기](#{discussion_url discussion})
EOF
    when "opinions#create"
      opinion = object
      discussion = opinion.discussion

      return <<EOF
논의 "#{discussion.subject}"
@#{current_user.nickname}님이 의견을 올렸습니다.
#{opinion.body} >>> [보기](#{opinion_url opinion})
EOF
    when "opinions#update"
      opinion = object
      discussion = opinion.discussion

      return <<EOF
논의 "#{discussion.subject}"
@#{current_user.nickname}님이 의견을 고쳤습니다.
#{opinion.body} >>> [보기](#{opinion_url opinion})
EOF
    when "opinions#destroy"
      opinion = object
      discussion = opinion.discussion

      return <<EOF
논의 "#{discussion.subject}"
@#{current_user.nickname}님이 의견을 지웠습니다.
#{opinion.body} >>> [보기](#{discussion_url discussion})
EOF
    when "votes#in_favor", "votes#opposed"
      vote = object
      proposal = vote.proposal
      discussion = proposal.discussion

      return <<EOF
논의 "#{discussion.subject}"
@#{current_user.nickname}님이 "#{proposal.body}" 제안에 투표합니다.
>>> [보기](#{discussion_url discussion})
EOF
    when "votes#unvote"
      vote = object
      proposal = vote.proposal
      discussion = proposal.discussion

      return <<EOF
논의 "#{discussion.subject}"
#{current_user.nickname}님이 "#{proposal.body}" 제안에 투표철회합니다.
>>> [보기](#{discussion_url discussion})
EOF
    else
      nil
    end
  end
end
