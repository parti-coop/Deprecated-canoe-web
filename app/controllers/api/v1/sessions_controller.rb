class Api::V1::SessionsController < Api::V1::BaseController
  skip_before_filter :authenticate_token!

  def facebook
    begin
      access_token = params[:access_token]
      nickname = params[:nickname]

      @graph = Koala::Facebook::API.new access_token
      profile = @graph.get_object("me", fields: ['id', 'email'])
      picture = @graph.get_picture_data("me")
    rescue Exception => e
      logger.info e.message
      e.backtrace.each { |line| logger.info line }
      error!(:unauthenticated)
    end

    user = User.find_by(provider: 'facebook', uid: profile.dig("id"))
    unless user.present?
      if nickname.blank?
        error!(:not_found, metadata: {message: 'not found'}) and return
      end
      user = User.new(uid: profile.dig("id"), provider: 'facebook',
        nickname: nickname, email: profile.dig("email"),
        password: Devise.friendly_token[0,20], confirmed_at: DateTime.now)
      user.remote_image_url = picture.try(:dig, 'data', 'url')
      if user.save
        expose({ auth_token: user.authentication_token })
      else
        error!(:invalid_resource, user.errors)
      end
    else
      if nickname.present? and (nickname != user.nickname)
        error!(:bad_request, metadata: {message: 'invalid nickname'})
      else
        expose({ auth_token: user.authentication_token })
      end
    end
  end
end
