# TEST web hook url : "https://hooks.slack.com/services/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"

module SlackNotifing
  extend ActiveSupport::Concern

  def slack(object)
    return if ApplicationController::skip_slack
    return unless user_signed_in?

    @webhook_url = fetch_webhook_url(object)
    return if @webhook_url.blank?

    notifier = Slack::Notifier.new(@webhook_url, username: 'parti-canoe')

    message = make_message(object)
    if message.present?
      notifier.ping("[Canoe!] #{message[:title]}", attachments: [{ text: message[:body], color: "#36a64f" }])
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
    title = ""
    body = ""

    case "#{controller_name}##{action_name}"
    when "canoes#create"
      canoe = object
      title = "@#{current_user.nickname}님이 카누를 만들었습니다."
      body = "[#{canoe.title}](#{canoe_url canoe}) >>> #{canoe.theme}"
    when "canoes#update"
      canoe = object
      title = "@#{current_user.nickname}님이 카누를 고쳤습니다."
      body = "[#{canoe.title}](#{canoe_url canoe}) >>> #{canoe.theme}"
    when "canoes#destroy"
      canoe = object
      title = "@#{current_user.nickname}님이 카누를 지웠습니다."
      body = "#{canoe.title} >>> #{canoe.theme}"
    when "discussions#create"
      discussion = object
      title = "@#{current_user.nickname}님이 논의를 만들었습니다."
      body = "[#{discussion.subject}](#{discussion_url discussion}) >>> #{discussion.body}"
    when "discussions#update"
      discussion = object
      title = "@#{current_user.nickname}님이 논의를 고쳤습니다."
      body = "[#{discussion.subject}](#{discussion_url discussion}) >>> #{discussion.body}"
    when "discussions#destroy"
      discussion = object
      title = "@#{current_user.nickname}님이 논의를 지웠습니다."
      body = "#{discussion.subject} >>> #{discussion.body}"
    when "proposals#create"
      proposal = object
      discussion = proposal.discussion
      title = "@#{current_user.nickname}님이 제안을 만들었습니다."
      body = "[#{discussion.subject}](#{discussion_url discussion}) >>> #{proposal.body}"
    when "proposals#update"
      proposal = object
      discussion = proposal.discussion
      title = "@#{current_user.nickname}님이 제안을 고쳤습니다."
      body = "[#{discussion.subject}](#{discussion_url discussion}) >>> #{proposal.body}"
    when "proposals#destroy"
      proposal = object
      discussion = proposal.discussion
      title = "@#{current_user.nickname}님이 제안을 지웠습니다."
      body = "#{discussion.subject} >>> #{proposal.body}"
    when "opinions#create"
      opinion = object
      discussion = opinion.discussion
      title = "@#{current_user.nickname}님이 의견을 올렸습니다."
      body = "[#{discussion.subject}](#{opinion_url opinion}) >>> #{opinion.body}"
    when "opinions#update"
      opinion = object
      discussion = opinion.discussion
      title = "@#{current_user.nickname}님이 의견을 고쳤습니다."
      body = "[#{discussion.subject}](#{opinion_url opinion}) >>> #{opinion.body}"
    when "opinions#destroy"
      opinion = object
      discussion = opinion.discussion
      title = "@#{current_user.nickname}님이 의견을 지웠습니다."
      body = "#{discussion.subject} >>> #{opinion.body}"
    when "votes#in_favor", "votes#opposed"
      vote = object
      proposal = vote.proposal
      discussion = proposal.discussion
      title = "@#{current_user.nickname}님이 #{proposal.body} 제안에 투표합니다."
      body = "[#{discussion.subject}](#{discussion_url discussion})"
    when "votes#unvote"
      vote = object
      proposal = vote.proposal
      discussion = proposal.discussion
      title = "@#{current_user.nickname}님이 #{proposal.body} 제안에 투표철회합니다."
      body = "[#{discussion.subject}](#{discussion_url discussion})"
    else
      nil
    end
    return { title: title, body: body }
  end
end
