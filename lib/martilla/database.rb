require 'forwardable'

module Martilla
  class Database
    attr_reader :options

    def initialize(config)
      @options = config
      raise Error.new(invalid_options_msg) if @options.nil?
    end

    def dump(temp_file:, gzip:)
      raise NotImplementedError, 'You must implement the dump method'
    end

    def invalid_options_msg
      'DB configuration is invalid. Details here: https://github.com/fdoxyz/martilla'
    end

    # When a new DB is supported it needs to go here
    def self.create(config = {})
      case config['type'].downcase
      when 'postgres'
        Postgres.new(config['options'])
      when 'mysql'
        Mysql.new(config['options'])
      else
        raise Error.new("Invalid Database type: #{config['type']}")
      end
    end
  end
end
