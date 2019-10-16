require 'pony'

module Martilla
  class EmailNotifier < Notifier
    private

    def success_html(data)
      data_list = data.map { |d| "<li>#{d}</li>" }.join("\n")
      <<~HTML
        <h2>The backup was created successfully</h2>
        <ul>
          #{data_list}
        </ul>
      HTML
    end

    def success_txt(data)
      data_list = data.map { |d| "- #{d}" }.join("\n")
      <<~TXT
        The backup was created successfully

        #{data_list}
      TXT
    end

    def error_html(msg, data)
      data_list = data.map { |d| "<li>#{d}</li>" }.join("\n")
      <<~HTML
        <h2>The backup attempt failed with the following error</h2>
        <p><strong>#{msg}</strong></p>
        <ul>
          #{data_list}
        </ul>
      HTML
    end

    def error_txt(msg, data)
      data_list = data.map { |d| "- #{d}" }.join("\n")
      <<~TXT
        The backup attempt failed with the following error:
        #{msg}

        #{data_list}
      TXT
    end

    def to_email
      email = @options['to']
      raise config_error('to') if email.nil?
      email
    end

    def from_email
      @options['from'] || 'martilla@no-reply.com'
    end
  end
end
