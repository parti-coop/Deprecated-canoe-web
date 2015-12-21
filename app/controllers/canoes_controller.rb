class CanoesController < ApplicationController

  before_filter :authenticate_user!, except: [:index, :show, :short]
  before_filter :fetch_canoe, only: [:show, :edit, :update, :destroy]
  before_filter :correct_user, only: [:edit, :update, :destroy]

  def index
    @canoes = Canoe.all
  end

  def show
    redirect_to short_canoe_path(@canoe.slug)
  end

  def short
    @canoe = Canoe.find_by slug: params[:slug]
    render 404 if @canoe.nil?

    render 'show'
  end

  def new
    @canoe = Canoe.new
  end

  def edit
  end

  def create
    @canoe = Canoe.new canoe_params
    @canoe.user = current_user
    if @canoe.save
      redirect_to @canoe
    else
      render 'new'
    end
  end

  def update
    @canoe.update(canoe_params)
    redirect_to @canoe
  end

  def destroy
    @canoe.destroy
    redirect_to canoes_path
  end

  private

  def fetch_canoe
    @canoe ||= Canoe.find params[:id]
  end

  def correct_user
    unless fetch_canoe.user == current_user
      redirect_to(@canoe)
    end
  end

  def canoe_params
    params.require(:canoe).permit(:title, :theme, :slug)
  end
end
