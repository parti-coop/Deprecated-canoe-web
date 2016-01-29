class SearchController < ApplicationController
  def index
    query = params[:q]
    unless query.blank?
      model = params[:model]
      if model.blank?
        @canoes = Canoe.search_for(params[:q])
        @canoes_count = @canoes.count
        @canoes_on_current_page = @canoes.limit(6)

        @discussions = Discussion.valid_parent.order(discussed_at: :desc).search_for(params[:q])
        @discussions_count = @discussions.count
        @discussions_on_current_page = @discussions.limit(5)
      else
        klass = model.singularize.capitalize.constantize
        @models = klass.search_for(params[:q]).page(params[:page])
        @models = @models.valid_parent if @models.respond_to?(:valid_parent)
        @models_count = @models.count
        @models_on_current_page = @models.page(params[:page])
        render template: "search/#{model.pluralize}"
      end
    end
  end
end
