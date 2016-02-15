class CanoesController < ApplicationController
  include SlackPushing
  include Messaging

  before_filter :authenticate_user!, except: [:index, :show, :short, :history]
  load_and_authorize_resource except: [:index, :short]

  def index
    if params[:list] == 'all'
      @canoes = Canoe.all
    else
      authenticate_user!
      @canoes = current_user.joined_canoes
    end

    @canoes = @canoes.page(params[:page])
  end

  def show
    redirect_to short_canoe_path(@canoe.slug)
  end

  def short
    @canoe = Canoe.find_by slug: params[:slug]
    render_404 and return unless @canoe.present?

    @discussions = @canoe.discussions.persisted.order(discussed_at: :desc)
    if params[:discussions] == 'decided'
      @discussions = @discussions.where.not(decision: [nil, ''])
    end
    if params[:discussions] == 'undecided'
      @discussions = @discussions.where(decision: [nil, ''])
    end
    render 'show'
  end

  def new
  end

  def edit
  end

  def create
    @canoe.user = current_user
    if @canoe.save
      push_to_slack(@canoe)
      redirect_to @canoe
    else
      render 'new'
    end
  end

  def update
    if @canoe.update_attributes(update_params)
      push_to_slack(@canoe)
      redirect_to @canoe
    else
      render 'edit'
    end
  end

  def destroy
    @canoe.destroy
    notify_to_crews(@canoe)
    push_to_slack(@canoe)
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

  def history
  end

  private

  def create_params
    params.require(:canoe).permit(:title, :theme, :slug, :cover, :logo, :is_able_to_request_to_join, :slack_webhook_url)
  end

  def update_params
    params.require(:canoe).permit(:title, :theme, :slug, :cover, :logo, :is_able_to_request_to_join, :slack_webhook_url)
  end
end
