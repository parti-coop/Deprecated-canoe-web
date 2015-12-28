class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  cattr_accessor(:skip_slack) { !Rails.env.staging? }

  include PartiSsoClient::Authentication
  before_action :verify_authentication

  def redirect_to(*args)
    if args[0].class == Canoe and args[0].persisted?
      super short_canoe_path(args[0].slug), *args[1..-1]
    else
      super *args
    end
  end
end
