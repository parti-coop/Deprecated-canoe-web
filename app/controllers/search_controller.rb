class SearchController < ApplicationController
  def index
    query = params[:q]
    @all = (params[:all] || 'false') == 'true'
    if query.present?
      if @all
        @discussions = Discussion.valid_parent.order(discussed_at: :desc).search_for(query)
      else
        @discussions = current_user.crewing_discussions.order(discussed_at: :desc).search_for(query)
      end
      @discussions_count = @discussions.count
      @discussions_on_current_page = @discussions.page(params[:page])
    end
  end
end
