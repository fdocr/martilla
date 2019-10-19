module Martilla
  class Postgres < Database
    def dump(tmp_file:, gzip:)
      if gzip
        `pg_dump #{connection_string} | gzip -c > #{tmp_file}`
      else
        `pg_dump #{connection_string} > #{tmp_file}`
      end

      return if $?.success?
      raise Error.new("Database dump failed with code #{$?.exitstatus}")
    end

    private

    def connection_string
      "postgres://#{user}:#{password}@#{host}:#{port}/#{db}"
    end

    def host
      @options['host'] || ENV['PG_HOST'] || 'localhost'
    end

    def port
      @options['port'] || ENV['PG_PORT'] || '5432'
    end

    def user
      @options['user'] || ENV['PG_USER']
    end

    def password
      @options['password'] || ENV['PG_PASSWORD']
    end

    def db
      @options['db'] || ENV['PG_DATABASE']
    end
  end
end
