class CanoesController < ApplicationController
  include SlackNotifing
  include Messaging

  before_filter :authenticate_user!, except: [:show, :short]
  load_and_authorize_resource except: [:index, :short]

  def index
    @canoes = params[:list] == 'all' ? Canoe.all : current_user.crewing_canoes
  end

  def show
    redirect_to short_canoe_path(@canoe.slug)
  end

  def short
    @canoe = Canoe.find_by slug: params[:slug]
    render_404 and return if @canoe.nil?
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
    notify_to_crews(@canoe)
    slack(@canoe)
    redirect_to canoes_path
  end

  private

  def create_params
    params.require(:canoe).permit(:title, :theme, :slug, :cover, :logo, :slack_webhook_url)
  end

  def update_params
    params.require(:canoe).permit(:title, :theme, :slug, :cover, :logo, :slack_webhook_url)
  end
end
