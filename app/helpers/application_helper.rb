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
    smart_text = text.gsub(/(?:^|\s)제안(\d+)/u) do |m|
      sequential_id = $1
      proposal = opinion.discussion.proposals.find_by sequential_id: sequential_id
      if proposal.present?
        m.gsub($1, "<span class='label label-danger' data-toggle='tooltip' data-placement='bottom' title='#{strip_tags proposal.body.squish} [자세히보기]' data-anchor='proposal' data-proposal-id='#{proposal.id}' style='cursor: pointer;'>#{$1}</span>")
      else
        m
      end
    end
    auto_link(smart_text)
  end
end
