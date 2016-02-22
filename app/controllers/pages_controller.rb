class PagesController < ApplicationController
  def home
    session[SSO_RETURN_TO_KEY] = root_url

    limit_count = 30
    if user_signed_in?
      @discussions = current_user.joined_discussions.reorder(discussed_at: :desc).first(limit_count)
      @canoes = current_user.joined_canoes
      @canoes = Canoe.limit(limit_count) if @canoes.empty?
      current_user.touch_home
      current_user.save
    end

    prepare_meta_tags title: "안녕하세요?", description: "모든 카누입니다."

    @canoes ||= Canoe.limit(limit_count)
  end
end
