class PagesController < ApplicationController
  def home
    session[SSO_RETURN_TO_KEY] = root_url

    limit = 30
    if user_signed_in?
      @discussions = current_user.joined_discussions.order(discussed_at: :desc).first(limit)
      @canoes = current_user.joined_canoes
      current_user.touch_home
      current_user.save
    end

    if @canoes.empty?
      @canoes = Canoe.limit(20)
    end
  end
end
