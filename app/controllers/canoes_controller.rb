class CanoesController < ApplicationController

  def index
    @canoes = Canoe.all
  end

  def show
    @canoe = Canoe.find params[:id]
  end

  def new
    @canoe = Canoe.new
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

  private

  def canoe_params
    params.require(:canoe).permit(:title)
  end
end
