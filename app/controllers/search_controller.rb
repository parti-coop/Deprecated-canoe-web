class SearchController < ApplicationController
  def discussions
    query = params[:q]
    @all = (params[:all] || 'false') == 'true'
    @all = true unless user_signed_in?
    if query.present?
      if @all
        @discussions = Discussion.valid_parent.order(discussed_at: :desc).search_for(query)
      else
        @discussions = current_user.joined_discussions.order(discussed_at: :desc).search_for(query)
      end
      @discussions_count = @discussions.count
      @discussions_on_current_page = @discussions.page(params[:page])
    end
  end

  def canoes
    query = params[:q]
    if query.present?
      @canoes = Canoe.search_for(query)
      @canoes_count = @canoes.count
      @canoes_on_current_page = @canoes.page(params[:page])
    end
  end
end
