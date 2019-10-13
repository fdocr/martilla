require 'pony'

module Martilla
  class Smtp < Notifier
    def success(data)


      Pony.mail({
        :to => 'you@example.com',
        :via => :smtp,
        :via_options => {
          :address        => 'smtp.yourserver.com',
          :port           => '25',
          :user_name      => 'user',
          :password       => 'password',
          :authentication => :plain, # :plain, :login, :cram_md5, no auth by default
          :domain         => "localhost.localdomain" # the HELO domain provided by the client to the server
        }
      })
    end

    def error(msg, data)
      puts "ERROR WHILE PERFORMING THE BACKUP: #{msg}"
    end

    private

    def to
      email = @options['to']
      raise config_error('to') if email.nil?
      email
    end

    def address
      email = @options['address']
      raise config_error('address') if email.nil?
      email
    end

    def port
      @options['port'] || '25'
    end
  end
end
