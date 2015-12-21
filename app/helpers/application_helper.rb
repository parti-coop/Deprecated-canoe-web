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
end
