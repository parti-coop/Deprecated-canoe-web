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

  def link_to_if_with_block condition, options, html_options={}, &block
    if condition
      link_to options, html_options, &block
    else
      capture &block
    end
  end

  def user_byline(user)
    return if user.nil?
    raw render(partial: 'users/byline', locals: { user: user })
  end

  def reaction_label(opinion, token, count)
    raw render(partial: 'application/reaction_label', locals: { opinion: opinion, token: token, count: count })
  end

  def opinion_body(opinion)
    text = opinion.body
    parsed_text = text.gsub(/(?:^|\s)제안(\d+)/u) do |m|
      sequential_id = $1
      proposal = opinion.discussion.proposals.find_by sequential_id: sequential_id
      if proposal.present?
        m.gsub($1, "<span class='label label-danger' data-toggle='tooltip' data-placement='bottom' title='#{strip_tags proposal.body.squish}' data-anchor='proposal' data-proposal-id='#{proposal.id}' style='cursor: pointer;'>#{$1}</span>")
      else
        m
      end
    end
    smart_body(parsed_text, { class: 'opinion__body', data: { toggle: 'preview', stage: "##{dom_id(opinion)} .attachments--image" } })
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
