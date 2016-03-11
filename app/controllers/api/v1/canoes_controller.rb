class Api::V1::CanoesController < Api::V1::BaseController
  def show
    @canoe = Canoe.find params[:id]
    expose @canoe,
      include: {
        user: {},
        discussions: { include: [:newest_opinion, :newest_proposal] },
        crews: { include: [:user] },
        request_to_joins: { include: [:user] },
        invitations: { include: [:user] }
      }
  end
end

