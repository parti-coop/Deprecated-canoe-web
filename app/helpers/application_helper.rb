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
end
