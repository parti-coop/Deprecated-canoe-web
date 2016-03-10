class Api::V1::SearchController < Api::V1::BaseController
  def discussions
    query = params.require(:q)
    @all = (params[:all] || 'false') == 'true'
    if @all
      @discussions = Discussion.valid_parent.order(discussed_at: :desc).search_for(query)
    else
      @discussions = current_user.joined_discussions.order(discussed_at: :desc).search_for(query)
    end
    paginated @discussions.page(params[:page])
  end

  def canoes
    query = params.require(:q)
    @canoes = Canoe.search_for(query)
    paginated @canoes.page(params[:page])
  end
end

