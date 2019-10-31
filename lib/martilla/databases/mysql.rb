module Martilla
  class Mysql < Database
    def dump(tmp_file:, gzip:)
      if gzip
        bash("set -o pipefail && mysqldump #{connection_arguments} | gzip -c > #{tmp_file}")
      else
        bash("mysqldump #{connection_arguments} > #{tmp_file}")
      end

      return if $?.success?
      raise Error.new("Database dump failed with code #{$?.exitstatus}")
    end

    private

    def connection_arguments
      "-u #{user} -p #{password} -P #{port} #{db}"
    end

    def host
      @options['host'] || ENV['MYSQL_HOST'] || 'localhost'
    end

    def port
      @options['port'] || ENV['MYSQL_PORT'] || '3306'
    end

    def user
      @options['user'] || ENV['MYSQL_USER']
    end

    def password
      @options['password'] || ENV['MYSQL_PASSWORD']
    end

    def db
      @options['db'] || ENV['MYSQL_DATABASE']
    end
  end
end
