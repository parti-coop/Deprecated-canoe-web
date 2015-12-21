class CrewsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :fetch_canoe
  before_filter :correct_user

  def new
    @crew = @canoe.crews.new
  end

  def create
    redirect_to @canoe and return if @canoe.crew? fetch_user
    @crew = @canoe.crews.build
    @crew.user = fetch_user
    @crew.inviter = current_user
    if @crew.user.present? and @crew.save
      redirect_to @canoe
    else
      render 'new'
    end
  end

  def index
  end

  private

  def fetch_user
    user_key = params[:crew][:user_key]
    user = User.find_by(nickname: user_key) || User.find_by(email: user_key) || User.sync(user_key)
  end

  def fetch_canoe
    @canoe ||= Canoe.find params[:canoe_id]
  end

  def correct_user
    redirect_to @canoe unless @canoe.crew? current_user
  end
end
