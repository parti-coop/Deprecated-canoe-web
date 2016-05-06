class PushSender
  attr_reader :ios_pusher, :android_pusher

  def initialize
    @android_pusher = GCM.new(ENV['GCM_API_KEY'])
    @ios_pusher = Grocer.pusher(
      certificate: Rails.root.join('config/apns.pem'),
      gateway: (Rails.env.production? ? "gateway.sandbox.push.apple.com" : "gateway.push.apple.com")
    )
  end

  def push_now(user, message)
    Device.where(user: user).each do |device|
      if device.device_platform == 'android'
        options = {data: {alert: message}, collapse_key: "akey"}
        response = @android_pusher.send([device.device_id], options)
      elsif device.device_platform == 'ios'
        notification = Grocer::Notification.new(
          device_token:      device.device_id,
          alert:             message,
          # badge:             42,
          # category:          "a category",         # optional; used for custom notification actions
          # sound:             "siren.aiff",         # optional
          # expiry:            Time.now + 60*60,     # optional; 0 is default, meaning the message is not stored
          # identifier:        1234,                 # optional; must be an integer
          # content_available: true                  # optional; any truthy value will set 'content-available' to 1
        )
        @ios_pusher.push(notification)
      end
    end
  end
end
