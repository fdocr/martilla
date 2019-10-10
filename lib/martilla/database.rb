require 'forwardable'

module Martilla
  class Database
    extend Forwardable

    def initialize(config)
      # When a new core target is added to the project include it here
      case config['type'].downcase
      when 'postgres'
        @database = Databases::Postgres.new(config['options'])
      when 'mysql'
        @database = Databases::Mysql.new(config['options'])
      else
        raise Error.new("Invalid Database type: #{config['type']}")
      end
    end

    def_delegators :@database, :dump
  end
end
