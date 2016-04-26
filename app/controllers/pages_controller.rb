class PagesController < ApplicationController
  def home
    limit_count = 30
    if user_signed_in?
      @discussions = current_user.joined_discussions.reorder(discussed_at: :desc).first(limit_count)
      @canoes = current_user.joined_canoes
      @canoes = Canoe.limit(limit_count) if @canoes.empty?
      current_user.touch_home
      current_user.save
    end

    @canoes ||= Canoe.limit(limit_count)
  end
end
