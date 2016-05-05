class Api::V1::UsersController < Api::V1::BaseController
  skip_before_filter :authenticate_token!, only: :exist

  def exist
    expose User.exists?(nickname: params[:nickname])
  end

  def kill_me
    current_user.update_attributes(uid: SecureRandom.hex(10))
    head :ok
  end
end
