require 'pony'

module Martilla
  class Smtp < EmailNotifier
    def success(data)
      Pony.mail(to: to_email,
                from: from_email,
                subject: success_subject,
                via: :smtp,
                html_body: success_html(data),
                body: success_txt(data),
                via_options: via_options)
    end

    def error(msg, data)
      Pony.mail(to: to_email,
                from: from_email,
                subject: error_subject,
                via: :smtp,
                html_body: error_html(msg, data),
                body: error_txt(msg, data),
                via_options: via_options)
    end

    private

    def via_options
      {
        address: address,
        port: port,
        user_name: user_name,
        password: password,
        authentication: authentication, # :plain, :login, :cram_md5, no auth by default
        domain: domain # the HELO domain provided by the client to the server
      }
    end

    def address
      email = @options['address']
      raise config_error('address') if email.nil?
      email
    end

    def domain
      smtp_domain = @options['domain']
      raise config_error('domain') if smtp_domain.nil?
      smtp_domain
    end

    def user_name
      smtp_user_name = @options['user_name']
      raise config_error('user_name') if smtp_user_name.nil?
      smtp_user_name
    end

    def password
      smtp_password = @options['password']
      raise config_error('password') if smtp_password.nil?
      smtp_password
    end

    def port
      @options['port'] || '25'
    end

    def authentication
      @options['authentication'] || :plain
    end
  end
end
