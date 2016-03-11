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

  def refute_captain!
    if @canoe.captain?(current_user)
      error! :forbidden, metadata: { error_description: 'You are captain' }
    end
  end

  def assert_canoe!
    error! :not_found, metadata: { error_description: 'Not found canoe' } if @canoe.nil?
  end

  def assert_crew!
    if !@canoe.crew?(current_user)
      error! :forbidden, metadata: { error_description: 'You are not crew' }
    end
  end

  def refute_crew!
    refute_crew_of!(current_user)
  end

  def refute_crew_of!(someone)
    if @canoe.crew?(someone)
      error! :forbidden, metadata: { error_description: "@#{someone.nickname} is already crew" }
    end
  end

  def assert_canoe_to_be_able_to_request_to_join!
    if !@canoe.is_able_to_request_to_join?
      error! :conflict, 'This canoe was prohibited to request to join'
    end
  end

  def refute_invited!
    refute_invited_of!(current_user)
  end

  def refute_invited_of!(someone)
    if @canoe.invited?(someone)
      error! :conflict, "@#{someone.nickname} is already invited"
    end
  end

  def assert_current_user!(someone)
    if someone != current_user
      error! :forbidden
    end
  end

  def assert_crew_or_current_user!(someone)
    if someone != current_user and !@canoe.crew?(current_user)
      error! :forbidden
    end
  end
end
