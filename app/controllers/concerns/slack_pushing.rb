# TEST web hook url : "https://hooks.slack.com/services/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"

module SlackPushing
  extend ActiveSupport::Concern

  def push_to_slack(object)
    return if ApplicationController::skip_slack
    return unless user_signed_in?

    @webhook_url = fetch_webhook_url(object)
    return if @webhook_url.blank?

    notifier = Slack::Notifier.new(@webhook_url, username: 'parti-canoe')

    message = make_message(object)
    if message.present?
      notifier.ping("[Canoe!!:[#{@canoe.title}](#{view_context.canoe_home_url @canoe})] #{message[:title]}", attachments: [{ text: message[:body], color: "#36a64f" }])
    end
  end

  private

  def fetch_webhook_url(object)
    @canoe = object if object.class == Canoe
    @canoe ||= object.discussion.canoe if object.respond_to?(:discussion)
    @canoe ||= object.canoe if object.respond_to?(:canoe)

    @canoe.try(:slack_webhook_url)
  end

  def make_message(object)
    title = ""
    body = ""

    case "#{controller_name}##{action_name}"
    when "canoes#create"
      canoe = object
      title = "@#{current_user.nickname}님이 카누를 만들었습니다."
      body = "[#{canoe.title}](#{view_context.canoe_home_url canoe}) >>> #{canoe.theme}"
    when "canoes#update"
      canoe = object
      title = "@#{current_user.nickname}님이 카누를 고쳤습니다."
      body = "[#{canoe.title}](#{view_context.canoe_home_url canoe}) >>> #{canoe.theme}"
    when "canoes#destroy"
      canoe = object
      title = "@#{current_user.nickname}님이 카누를 지웠습니다."
      body = "#{canoe.title} >>> #{canoe.theme}"
    when "discussions#create"
      discussion = object
      title = "@#{current_user.nickname}님이 논의를 만들었습니다."
      body = "논의: [#{discussion.subject}](#{view_context.discussion_home_url discussion})"
    when "discussions#update"
      discussion = object
      title = "@#{current_user.nickname}님이 논의를 고쳤습니다."
      body = "논의: [#{discussion.subject}](#{view_context.discussion_home_url discussion})"
    when "discussions#destroy"
      discussion = object
      title = "@#{current_user.nickname}님이 논의를 지웠습니다."
      body = "논의: #{discussion.subject}"
    when "proposals#create"
      proposal = object
      discussion = proposal.discussion
      title = "@#{current_user.nickname}님이 제안을 만들었습니다."
      body = "#{proposal.body}\n논의: [#{discussion.subject}](#{view_context.discussion_home_url discussion})"
    when "proposals#update"
      proposal = object
      discussion = proposal.discussion
      title = "@#{current_user.nickname}님이 제안을 고쳤습니다."
      body = "#{proposal.body}\n논의: [#{discussion.subject}](#{view_context.discussion_home_url discussion})"
    when "proposals#destroy"
      proposal = object
      discussion = proposal.discussion
      title = "@#{current_user.nickname}님이 제안을 지웠습니다."
      body = "#{proposal.body}\n논의: [#{discussion.subject}](#{view_context.discussion_home_url discussion})"
    when "opinions#create"
      opinion = object
      discussion = opinion.discussion
      title = "@#{current_user.nickname}님이 의견을 올렸습니다."
      body = "#{opinion.body}\n논의: [#{discussion.subject}](#{view_context.discussion_home_url discussion})"
    when "opinions#update"
      opinion = object
      discussion = opinion.discussion
      title = "@#{current_user.nickname}님이 의견을 고쳤습니다."
      body = "#{opinion.body}\n논의: [#{discussion.subject}](#{view_context.discussion_home_url discussion})"
    when "opinions#destroy"
      opinion = object
      discussion = opinion.discussion
      title = "@#{current_user.nickname}님이 의견을 지웠습니다."
      body = "#{opinion.body}\n논의: [#{discussion.subject}](#{view_context.discussion_home_url discussion})"
    when "votes#in_favor"
      vote = object
      proposal = vote.proposal
      discussion = proposal.discussion
      title = "@#{current_user.nickname}님이 #{proposal.body} 제안에 '좋아요'합니다."
      body = "논의: [#{discussion.subject}](#{view_context.discussion_home_url discussion})"
    when "votes#opposed"
      vote = object
      proposal = vote.proposal
      discussion = proposal.discussion
      title = "@#{current_user.nickname}님이 #{proposal.body} 제안에 '안돼요'합니다."
      body = "논의: [#{discussion.subject}](#{view_context.discussion_home_url discussion})"
    when "votes#unvote"
      vote = object
      proposal = vote.proposal
      discussion = proposal.discussion
      title = "@#{current_user.nickname}님이 #{proposal.body} 제안에 입장을 철회합니다."
      body = "논의: [#{discussion.subject}](#{view_context.discussion_home_url discussion})"
    when "request_to_joins#ask"
      request_to_join = object
      canoe = request_to_join.canoe
      title = "@#{current_user.nickname}님이 '#{canoe.title}' 카누에 가입을 요청합니다."
      body = "[#{canoe.title}](#{view_context.canoe_home_url canoe}) >>> #{canoe.theme}"
    when "request_to_joins#accept"
      request_to_join = object
      canoe = request_to_join.canoe
      title = "@#{current_user.nickname}님이 '#{canoe.title}' 카누에 @#{request_to_join.user.nickname}님의 가입을 허가합니다."
      body = "[#{canoe.title}](#{view_context.canoe_home_url canoe}) >>> #{canoe.theme}"
    when "invitations#create"
      invitation = object
      canoe = invitation.canoe
      title = "@#{current_user.nickname}님이 '#{canoe.title}' 카누에 #{invitation.guest_name}님을 초대합니다."
      body = "[#{canoe.title}](#{view_context.canoe_home_url canoe}) >>> #{canoe.theme}"
    when "invitations#destroy"
      invitation = object
      canoe = invitation.canoe
      title = "@#{current_user.nickname}님이 '#{canoe.title}' 카누의 #{invitation.guest_name}님 초대를 취소합니다."
      body = "[#{canoe.title}](#{view_context.canoe_home_url canoe}) >>> #{canoe.theme}"
    when "invitations#accept"
      invitation = object
      canoe = invitation.canoe
      title = "@#{current_user.nickname}님이 '#{canoe.title}' 카누에 초대를 수락합니다."
      body = "[#{canoe.title}](#{view_context.canoe_home_url canoe}) >>> #{canoe.theme}"
    when "crews#destroy"
      crew = object
      canoe = crew.canoe
      title = "@#{current_user.nickname}님이 '#{canoe.title}' 카누에서 탈퇴합니다."
      body = "[#{canoe.title}](#{view_context.canoe_home_url canoe}) >>> #{canoe.theme}"
    else
      return nil
    end
    return { title: title, body: body }
  end
end
