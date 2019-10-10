require 'forwardable'

module Martilla
  class Storage
    extend Forwardable

    def initialize(config)
      # When a new core target is added to the project include it here
      case config['type'].downcase
      when 'local'
        @storage = Storages::Local.new(config['options'])
      when 's3'
        @storage = Storages::S3.new(config['options'])
      when 'scp'
        @storage = Storages::Scp.new(config['options'])
      else
        raise Error.new("Invalid Storage type: #{config['type']}")
      end
    end

    def_delegators :@storage, :persist
  end
end
