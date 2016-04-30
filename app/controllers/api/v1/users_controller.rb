class Api::V1::UsersController < Api::V1::BaseController
  skip_before_filter :authenticate_token!

  def exist
    expose User.exists?(nickname: params[:nickname])
  end
end
