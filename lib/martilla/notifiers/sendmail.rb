require 'pony'

module Martilla
  class Sendmail < EmailNotifier
    def success(data)
      Pony.mail(to: to_email,
                from: from_email,
                subject: success_subject,
                html_body: success_html(data),
                body: success_txt(data))
    end

    def error(msg, data)
      Pony.mail(to: to_email,
                from: from_email,
                subject: error_subject,
                html_body: error_html(msg, data),
                body: error_txt(msg, data))
    end
  end
end
