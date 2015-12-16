class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  include PartiSsoClient::Authentication
  before_action :verify_authentication
end
