require 'forwardable'

module Martilla
  class Notifier
    extend Forwardable

    def initialize(config)
      # When a new core target is added to the project include it here
      case config['type'].downcase
      when 'email'
        @notifier = Notifiers::Email.new(config['options'])
      when 'ses'
        @notifier = Notifiers::Ses.new(config['options'])
      when 'slack'
        @notifier = Notifiers::Slack.new(config['options'])
      else
        raise Error.new("Invalid Notifier type: #{config['type']}")
      end
    end

    def_delegators :@notifier, :success, :error
  end
end
