class PushSender
  attr_reader :ios_pusher, :android_pusher

  def initialize
    @android_pusher = GCM.new(ENV['GCM_API_KEY'])
  end

  def push_now(user, message)
    Device.where(user: user).each do |device|
      if device.device_platform == 'android'
        options = {data: {alert: message}, collapse_key: "akey"}
        response = @android_pusher.send([device.device_id], options)
      end
    end
  end
end
