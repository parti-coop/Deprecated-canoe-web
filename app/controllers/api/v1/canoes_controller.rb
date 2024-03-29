class Api::V1::CanoesController < Api::V1::BaseController
  def show
    @canoe = Canoe.find params[:id]
    canoe_hash = hashed_detail_canoe(@canoe)
    canoe_hash.update discussions: hashed_discussions_with_newest(@canoe.discussions)

    expose({
      joined_canoes: current_user.joined_canoes,
      canoe: canoe_hash
    })
  end
end

