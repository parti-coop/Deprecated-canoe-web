class Api::V1::CanoesController < Api::V1::BaseController
  def show
    @canoe = Canoe.find params[:id]
    result = @canoe.serializable_hash include: {
      user: {},
      crews: { include: [:user] },
      request_to_joins: { include: [:user] },
      invitations: { include: [:user] },
      request_to_joins: { include: [:user] }
    }
    result.update discussions: hashed_discussions_with_newest(@canoe.discussions)
    expose(result)
  end
end

