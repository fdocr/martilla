module Martilla
  class Postgres < Database
    def dump(tmp_file:, gzip:)
      if gzip
        `pg_dump #{connection_string} | gzip -c > #{tmp_file}`
      else
        `pg_dump #{connection_string} > #{tmp_file}`
      end

      return nil if $?.success?
      raise Error.new("Database dump failed with code #{$?.exitstatus}")
    end

    private

    def connection_string
      "postgres://#{user}:#{password}@#{host}:#{port}/#{db}"
    end

    def host
      @options['host'] || 'localhost'
    end

    def port
      @options['port'] || '5432'
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
