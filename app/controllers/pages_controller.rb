class PagesController < ApplicationController
  def home
    session[SSO_RETURN_TO_KEY] = canoes_url

    @canoes = Canoe.latest.all
  end
end
