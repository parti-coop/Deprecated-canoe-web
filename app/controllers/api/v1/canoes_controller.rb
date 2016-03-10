class Api::V1::CanoesController < Api::V1::BaseController
  def show
    @canoe = Canoe.find params[:id]
    expose @canoe, include: {discussions: { include: [:newest_opinion, :newest_proposal] }, crews: {}}
  end
end

