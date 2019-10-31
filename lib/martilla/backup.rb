require 'memoist'
require 'martilla/utilities'

module Martilla
  class Backup
    extend Memoist

    include Utilities

    attr_reader :file_size

    def initialize(config)
      @options = config['options'] || {}
      @db = Database.create(config['db'])
      @storage = Storage.create(config['storage'])
      @notifiers = config['notifiers'].map { |c| Notifier.create(c) }.compact
    end

    def self.create(config)
      backup = Backup.new(config)
      backup.execute
      backup
    end

    def gzip?
      return true if @options['gzip'].nil?
      @options['gzip']
    end

    def tmp_file
      filename = @options.dig('tmp_file') || '/tmp/backup'
      return "#{filename}.gz" if gzip?
      filename
    end

    def execute
      begin
        # Perform DB dump
        @ticks = [Time.now]
        @db.dump(tmp_file: tmp_file, gzip: gzip?)

        # Metadata capture
        @file_size = File.size(tmp_file).to_f if File.exist?(tmp_file)
        @ticks << Time.now

        # Persist the backup
        @storage.persist(tmp_file: tmp_file, gzip: gzip?)
      rescue Exception => e
        @notifiers.each do |notifier|
          notifier.error(e.message, metadata)
        end
        puts "An error occurred: #{e.inspect}"
      else
        @notifiers.each do |notifier|
          notifier.success(metadata)
        end
        puts "Backup created and persisted successfully"
      end

      File.delete(tmp_file) if File.exist?(tmp_file)
    end

    def metadata
      @ticks << Time.now
      data = []

      # Total backup size
      if @file_size.nil?
        data << "No backup file was created"
      else
        data << "Total backup size: #{formatted_file_size}"
      end

      # Backup time measurements
      if @ticks.count >= 2
        time_diff = duration_format(@ticks[1] - @ticks[0])
        data << "Backup 'dump' duration: #{time_diff}"
      end

      # Storage time measurements
      if @ticks.count >= 3
        time_diff = duration_format(@ticks[2] - @ticks[1])
        data << "Backup storage duration: #{time_diff}"
      end

      data
    end
    memoize :metadata

    def self.sample_config
      {
        'db' => {
          'type' => 'postgres',
          'options' => {
            'host' => 'localhost',
            'user' => 'username',
            'password' => 'password',
            'db' => 'databasename'
          }
        },
        'storage' => {
          'type' => 'local',
          'options' => {
            'filename' => 'database-backup.sql'
          }
        },
        'notifiers' => [
          {
            'type' => 'none'
          }
        ]
      }
    end
  end
end
