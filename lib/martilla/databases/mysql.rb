module Martilla
  class Mysql < Database
    def dump(tmp_file:, gzip:)
      if gzip
        `mysqldump #{connection_arguments} | gzip -c > #{tmp_file}`
      else
        `mysqldump #{connection_arguments} > #{tmp_file}`
      end

      return nil if $?.success?
      raise Error.new("Database dump failed with code #{$?.exitstatus}")
    end

    private

    def connection_arguments
      "-u #{user} -p #{password} -P #{port} #{db}"
    end

    def host
      @options['host'] || 'local'
    end

    def port
      @options['port'] || '3306'
    end

    def user
      @options['user']
    end

    def password
      @options['password']
    end

    def db
      @options['db']
    end
  end
end
