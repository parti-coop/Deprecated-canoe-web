class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  cattr_accessor(:skip_slack) { !Rails.env.staging? }

  include PartiSsoClient::Authentication
  before_action :verify_authentication
  after_action :allow_iframe

  def redirect_to(*args)
    if args[0].class == Canoe and args[0].persisted?
      super short_canoe_path(args[0].slug), *args[1..-1]
    else
      super *args
    end
  end

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to main_app.root_url, :alert => exception.message
  end

  def render_404
    render file: "#{Rails.root}/public/404.html", layout: false, status: 404
  end

  private

  def allow_iframe
    response.headers.except! 'X-Frame-Options'
  end

end
