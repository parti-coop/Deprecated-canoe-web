class CrewsController < ApplicationController
  before_filter :authenticate_user!, except: [:index]
  load_and_authorize_resource :canoe
  load_and_authorize_resource :crew, through: :canoe, shallow: true

  def new
  end

  def index
  end

  def create
    redirect_to @canoe and return if @canoe.crew? fetch_user

    @crew.user = fetch_user
    @crew.inviter = current_user
    if @crew.user.present? and @crew.save
      redirect_to @canoe
    else
      render 'new'
    end
  end

  private

  def create_params
  end

  def fetch_user
    user_key = params[:crew][:user_key]
    @fetch_user ||= User.find_or_sync(user_key)
  end
end
