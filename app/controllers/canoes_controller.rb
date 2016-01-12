class CanoesController < ApplicationController
  include SlackNotifing
  before_filter :authenticate_user!, except: [:show, :short]
  load_and_authorize_resource except: [:index, :short]

  def index
    @owning_canoes = current_user.canoes
    @crewing_canoes = current_user.crewing_canoes
    @canoes = [@owning_canoes, @crewing_canoes].flatten
    @opinions = Opinion.joins(:discussion).where('discussions.canoe_id': @canoes).order(id: :desc)
  end

  def show
    redirect_to short_canoe_path(@canoe.slug)
  end

  def short
    @canoe = Canoe.find_by slug: params[:slug]
    render stauts: 404 if @canoe.nil?
    render 'show'
  end

  def new
  end

  def edit
  end

  def create
    @canoe.user = current_user
    if @canoe.save
      slack(@canoe)
      redirect_to @canoe
    else
      render 'new'
    end
  end

  def update
    if @canoe.update_attributes(update_params)
      slack(@canoe)
      redirect_to @canoe
    else
      render 'edit'
    end
  end

  def destroy
    @canoe.destroy
    slack(@canoe)
    redirect_to canoes_path
  end

  private

  def create_params
    params.require(:canoe).permit(:title, :theme, :slug, :cover, :logo, :slack_webhook_url)
  end

  def update_params
    params.require(:canoe).permit(:title, :theme, :slug, :cover, :logo, :board, :slack_webhook_url)
  end
end
