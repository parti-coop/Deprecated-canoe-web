class ReactionsController < ApplicationController
  before_filter :authenticate_user!
  load_and_authorize_resource

  def create
    @reaction.user = current_user
    @reaction.save unless Reaction.duplicated? @reaction
    redirect_to @reaction.opinion.discussion
  end

  def destroy
    @reaction.destroy
    redirect_to @reaction.opinion.discussion
  end
  private

  def reaction_params
    params.require(:reaction).permit(:opinion_id, :token)
  end
end
