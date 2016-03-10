class Api::V1::BaseController < Api::BaseController
  version 1

  before_filter :authenticate_token!

  def user_signed_in?
    @current_user.present?
  end

  def current_user
    @current_user
  end

  private

  def authenticate_token!
    @current_user ||= authenticate_with_http_token { |t,o| User.find_or_sync(t) }
    error! :unauthenticated unless @current_user.present?
  end
end
