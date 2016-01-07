class DashboardsController < ApplicationController
  before_filter :authenticate_user!

  def show
    @mentioned_opinions = Mention.where(user: current_user).order(created_at: :desc).map &:opinion
    @unvoted_proposals = current_user.crewing_proposals.order(created_at: :desc).select do |proposal|
      !proposal.voted?(current_user)
    end
  end
end
