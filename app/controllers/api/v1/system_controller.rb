class Api::V1::SystemController < Api::V1::BaseController
  skip_before_filter :authenticate_token!

  def last_version
    expose({ ios: "1.0.0", android: "1.0.0" })
  end

  def ping
    expose("pong")
  end
end
