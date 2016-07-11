if !Rails.env.development? and !Rails.env.test?

  Rails.application.config.middleware.use ExceptionNotification::Rack,
    # :email => {
    #   :email_prefix => "[PREFIX] ",
    #   :sender_address => %{"notifier" <notifier@example.com>},
    #   :exception_recipients => %w{exceptions@example.com}
    # },
    :slack => {
      :webhook_url => ENV["ERROR_SLACK_WEBHOOK_URL"],
      :additional_parameters => {
        :mrkdwn => true
      }
    }

end


