class CanoesController < ApplicationController
  include SlackNotifing
  include Messaging

  before_filter :authenticate_user!, except: [:index, :show, :short]
  load_and_authorize_resource except: [:index, :short]

  def index
    if params[:list] == 'all'
      @canoes = Canoe.all
    else
      authenticate_user!
      @canoes = current_user.crewing_canoes
    end
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

  def new_invitation
    @canoe = Canoe.find params[:canoe_id]
    redirect_to @canoe and return unless @canoe.crew? current_user
  end

  def create_invitation
    @canoe = Canoe.find params[:canoe_id]
    CanoeMailer.invite(@canoe, current_user, params[:email]).deliver_later
    redirect_to @canoe
  end

  private

  def create_params
    params.require(:canoe).permit(:title, :theme, :slug, :cover, :logo, :how_to_join, :slack_webhook_url)
  end

  def update_params
    params.require(:canoe).permit(:title, :theme, :slug, :cover, :logo, :how_to_join, :slack_webhook_url)
  end
end
