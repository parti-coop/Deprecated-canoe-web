class PagesController < ApplicationController
  def home
    session[SSO_RETURN_TO_KEY] = root_url

    @canoes = Canoe.latest.all
  end
end
