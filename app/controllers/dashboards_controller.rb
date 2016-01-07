class DashboardsController < ApplicationController
  before_filter :authenticate_user!

  def show
    @mentioned_opinions = Mention.where(user: current_user).order(created_at: :desc).map &:opinion
    #@proposals =
  end
end
