require 'forwardable'

module Martilla
  class Notifier < Component
    attr_reader :options

    def initialize(config)
      @options = config
      raise Error.new(invalid_options_msg) if @options.nil?
    end

    def success(data)
      raise NotImplementedError, 'You must implement the success method'
    end

    def error(msg, data)
      raise NotImplementedError, 'You must implement the error method'
    end

    def invalid_options_msg
      'Notifier configuration is invalid. Details here: https://github.com/fdoxyz/martilla'
    end

    # When a new Notifier is supported it needs to go here
    def self.create(config = {})
      case config['type'].downcase
      when 'sendmail'
        Sendmail.new(config['options'])
      when 'smtp'
        Smtp.new(config['options'])
      when 'ses'
        Ses.new(config['options'])
      when 'slack'
        Slack.new(config['options'])
      when 'none'
        nil
      else
        raise Error.new("Invalid Notifier type: #{config['type']}")
      end
    end
  end
end
