class Api::V1::SearchController < Api::V1::BaseController
  def discussions
    query = params.require(:q)
    @all = (params[:all] || 'false') == 'true'
    if @all
      @discussions = Discussion.valid_parent.order(discussed_at: :desc).search_for(query)
    else
      @discussions = current_user.joined_discussions.order(discussed_at: :desc).search_for(query)
    end

    paginated @discussions.page(params[:page]), metadata: { canoes_count: Canoe.search_for(query).count },
      each_serializer: Api::V1::SearchedDiscussionSerializer,
      serializer_params: { q: query }
  end

  def canoes
    query = params.require(:q)
    @canoes = Canoe.search_for(query)
    paginated @canoes.page(params[:page]), metadata: {
      all_discussions_count: Discussion.valid_parent.order(discussed_at: :desc).search_for(query).count,
      discussions_count: current_user.joined_discussions.search_for(query).count
    }
  end
end

