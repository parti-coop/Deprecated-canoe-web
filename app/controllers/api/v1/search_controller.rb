class Api::V1::SearchController < Api::V1::BaseController
  def discussions
    query = params.require(:q)
    @all = (params[:all] || 'false') == 'true'
    if @all
      @discussions = Discussion.valid_parent.order(discussed_at: :desc).search_for(query)
    else
      @discussions = current_user.joined_discussions.order(discussed_at: :desc).search_for(query)
    end
    @discussions = @discussions.page(params[:page])
    expose @discussions.map { |discussion| hashed_searched_discussion(discussion, query) },
      metadata: hashed_page_meta(@discussions).update(canoes_count: Canoe.search_for(query).count)
  end

  def canoes
    query = params.require(:q)
    @canoes = Canoe.search_for(query).page(params[:page])
    expose @canoes.map { |canoe| hashed_basic_canoe(canoe) }, metadata: hashed_page_meta(@canoes).update(
      all_discussions_count: Discussion.valid_parent.order(discussed_at: :desc).search_for(query).count,
      discussions_count: current_user.joined_discussions.search_for(query).count
    )
  end

  private

  def hashed_searched_discussion(discussion, query)
    discussion.serializable_hash(include: {
      user: {}
    }).update(
      canoe: hashed_basic_canoe(discussion.canoe),
      matched_proposal: hashed_matched_proposal(discussion, query),
      matched_opinion: hashed_matched_opinion(discussion, query)
    )
  end

  def hashed_matched_proposal(discussion, query)
    result = discussion.matched_newest_proposal(query)
    result.blank? ? nil : result.serializable_hash(include: [:user])
  end

  def hashed_matched_opinion(discussion, query)
    result = discussion.matched_newest_opinion(query)
    result.blank? ? nil : result.serializable_hash(include: [:user])
  end
end

