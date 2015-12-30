class CanoesController < ApplicationController
  include SlackNotifing

  before_filter :authenticate_user!, except: [:show, :short]
  before_filter :fetch_canoe, only: [:show, :edit, :update, :destroy]
  before_filter :correct_crew, only: [:edit, :update]
  before_filter :correct_captain, only: [:destroy]

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
    @canoe = Canoe.new
  end

  def edit
  end

  def create
    @canoe = Canoe.new create_params
    @canoe.user = current_user
    if @canoe.save
      slack(@canoe)
      redirect_to @canoe
    else
      render 'new'
    end
  end

  def update
    @canoe.update(update_params)
    slack(@canoe)
    redirect_to @canoe
  end

  def destroy
    @canoe.destroy
    slack(@canoe)
    redirect_to canoes_path
  end

  private

  def fetch_canoe
    @canoe ||= Canoe.find params[:id]
  end

  def correct_crew
    unless fetch_canoe.crew?(current_user)
      redirect_to(@canoe)
    end
  end

  def correct_captain
    unless fetch_canoe.user == current_user
      redirect_to(@canoe)
    end
  end

  def create_params
    params.require(:canoe).permit(:title, :theme, :slug, :cover, :logo)
  end

  def update_params
    params.require(:canoe).permit(:title, :theme, :slug, :cover, :logo, :board)
  end
end
