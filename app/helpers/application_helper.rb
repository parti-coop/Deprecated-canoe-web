module ApplicationHelper
  def date_f(date)
    if date.today?
      date.strftime("%H:%M")
    else
      date.strftime("%Y-%m-%d")
    end
  end

  def canoe_home_path(canoe, options = {})
    short_canoe_path(canoe.slug, options)
  end

  def canoe_home_url(canoe, options = {})
    short_canoe_url(canoe.slug, options)
  end

  def discussion_home_path(discussion, options = {})
    options.update(slug: discussion.canoe.slug, sequential_id: discussion.sequential_id)
    short_discussion_path(options)
  end

  def discussion_home_url(discussion, options = {})
    options.update(slug: discussion.canoe.slug, sequential_id: discussion.sequential_id)
    short_discussion_url(options)
  end

  def link_to_if_with_block condition, options, html_options={}, &block
    if condition
      link_to options, html_options, &block
    else
      capture &block
    end
  end

  def user_byline(user, only_image = false)
    return if user.nil?
    raw render(partial: 'users/byline', locals: { user: user, only_image: only_image })
  end

  def reaction_label(opinion, token, count)
    raw render(partial: 'application/reaction_label', locals: { opinion: opinion, token: token, count: count })
  end

  def opinion_body(opinion)
    text = opinion.body

    parsed_text = text.gsub(Mention::PATTERN_WITH_AT) do |m|
      at_nickname = $1
      nickname = at_nickname[1..-1]
      user = User.find_by nickname: nickname
      if user.present? or nickname == 'crew'
        m.gsub($1, "<span class='text-success'>#{$1}</span>")
      else
        m
      end
    end

    parsed_text.gsub!(/(?:^|\s)제안(\d+)/u) do |m|
      sequential_id = $1
      proposal = opinion.discussion.proposals.find_by sequential_id: sequential_id
      if proposal.present?
        m.gsub($1, "<a href='#proposal-#{proposal.sequential_id}' style='color: inherit; text-decoration: none;'><span class='label label-default'>#{$1}</span> <strong>\"#{truncate strip_tags proposal.body}\"</strong></a>")
      else
        m
      end
    end

    smart_body(parsed_text, { class: 'opinion__body', data: { toggle: 'preview', 'embed-stage': "##{dom_id(opinion)} .opinion__body--embeded", 'image-stage': "##{dom_id(opinion)} .attachments--image" } })
  end

  def smart_body(text, html_options = {}, options = {})
    simple_format(auto_link(text, html: {class: 'auto_link'}, link: :urls), html_options, options)
  end

  def current_canoe
    if params[:controller] == 'canoes'
      @canoe
    elsif params[:controller] == 'crews'
      @canoe
    elsif params[:controller] == 'discussions'
      @discussion.try(:canoe)
    elsif params[:controller] == 'opinions'
      (@opinion.try(:discussion) || @discussion).try(:canoe)
    elsif params[:controller] == 'proposals'
      (@proposal.try(:discussion) || @discussion).try(:canoe)
    elsif params[:controller] == 'request_to_joins'
      (@request_to_join.try(:discussion) || @discussion).try(:canoe)
    end
  end
end
