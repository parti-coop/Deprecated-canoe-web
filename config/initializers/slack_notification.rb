if !Rails.env.development? and !Rails.env.test?

  Rails.application.config.middleware.use ExceptionNotification::Rack,
    # :email => {
    #   :email_prefix => "[PREFIX] ",
    #   :sender_address => %{"notifier" <notifier@example.com>},
    #   :exception_recipients => %w{exceptions@example.com}
    # },
    :slack => {
      :webhook_url => "https://hooks.slack.com/services/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",
      :additional_parameters => {
        :mrkdwn => true
      }
    }

end
