require 'slack-notifier'

module Martilla
  class Slack < Notifier
    def success(data)
      slack_notify(success_txt(data))
    end

    def error(msg, data)
      slack_notify(error_txt(msg, data))
    end

    private

    def slack_notify(message)
      begin
        notifier.ping message
      rescue StandardError => e
        puts "Slack notification not sent. Error message: #{e}"
      end
    end

    def notifier
      ::Slack::Notifier.new(slack_webhook_url, channel: slack_channel, username: slack_username)
    end

    def slack_webhook_url
      raise config_error('slack_webhook_url') if @options['slack_webhook_url'].nil?
      @options['slack_webhook_url']
    end

    def slack_channel
      @options['slack_channel'] or "#general"
    end

    def slack_username
      @options['slack_username'] or "Martilla"
    end

    def success_txt(data)
      success_msg = "*The backup was created successfully*\n\n"
      success_msg + data.map { |d| "- #{d}" }.join("\n")
    end

    def error_txt(msg, data)
      error_msg = "*The backup attempt failed with the following error:*\n #{msg} \n\n"
      error_msg + data.map { |d| "- #{d}" }.join("\n")
    end

  end
end
