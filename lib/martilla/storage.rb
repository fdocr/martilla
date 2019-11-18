require 'forwardable'

module Martilla
  class Storage < Component
    attr_reader :options

    def initialize(config)
      @options = config
      raise Error.new(invalid_options_msg) if @options.nil?
    end

    def persist(temp_file:, gzip:)
      raise NotImplementedError, 'You must implement the persist method'
    end

    def enforce_retention!
      raise NotImplementedError, 'You must implement the enforce_retention! method'
    end

    def invalid_options_msg
      'Storage configuration is invalid. Details here: https://github.com/fdoxyz/martilla'
    end

    def suffix?
      return true if @options['suffix'].nil?
      @options['suffix']
    end

    def options_filename
      @options['filename'] || 'backup.sql'
    end

    def output_filename(gzip)
      filename = options_filename
      filename = append_datetime_suffix(filename) if suffix?
      filename = "#{filename}.gz" if gzip
      filename
    end

    def append_datetime_suffix(filename)
      dirname = File.dirname(filename)
      basename = File.basename(filename, '.*')

      # 'dir_with_name' is the original filename WITHOUT the extension
      dir_with_name = "#{dirname}/#{basename}"
      dir_with_name = basename if dirname == '.'

      extension = filename.gsub(dir_with_name, '')
      timestamp = Time.now.strftime("%Y-%m-%dT%H%M%S")
      "#{dirname}/#{basename}_#{timestamp}#{extension}"
    end

    def retention_limit
      @options['retention'].to_i
    end

    def timestamp_regex
      /\d{4}-\d{2}-\d{2}T\d{6}/
    end

    def config_error(config_name)
      Error.new("Storage adapter configuration requires #{config_name}. Details here: https://github.com/fdoxyz/martilla")
    end

    # When a new Storage is supported it needs to go here
    def self.create(config = {})
      case config['type'].downcase
      when 'local'
        Local.new(config['options'])
      when 's3'
        S3.new(config['options'])
      when 'scp'
        Scp.new(config['options'])
      else
        raise Error.new("Invalid Storage type: #{config['type']}")
      end
    end
  end
end
