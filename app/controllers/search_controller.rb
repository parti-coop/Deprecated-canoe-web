class SearchController < ApplicationController
  def index
    query = params[:q]
    unless query.blank?
      model = params[:model]
      if model.blank?
        @canoes = Canoe.search_for(params[:q])
        @canoes_count = @canoes.count
        @canoes_on_current_page = @canoes.limit(3)

        @discussions = Discussion.valid_parent.order(discussed_at: :desc).search_for(params[:q])
        @discussions_count = @discussions.count
        @discussions_on_current_page = @discussions.limit(5)
      else
        if model == 'canoe'
          @canoes = Canoe.search_for(params[:q])
          @canoes_count = @canoes.count
          @canoes_on_current_page = @canoes.page(params[:page])
          render template: "search/canoes"
        elsif model == 'discussion'
          @discussions = Discussion.valid_parent.order(discussed_at: :desc).search_for(params[:q])
          @discussions_count = @discussions.count
          @discussions_on_current_page = @discussions.page(params[:page])
          render template: "search/discussions"
        end
      end
    end
  end
end
