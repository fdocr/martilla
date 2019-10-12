require 'memoist'
require 'martilla/utilities'

module Martilla
  class Backup
    extend Memoist

    include Utilities

    def initialize(config)
      @options = config['options']
      @db = Database.create(config['db'])
      @storage = Storage.create(config['storage'])
      @notifiers = config['notifiers'].map { |c| Notifier.create(c) }
    end

    def self.create(config)
      backup = Backup.new(config)
      backup.execute
      backup
    end

    def gzip?
      @options['gzip'] || true
    end

    def tmp_file
      filename = @options.dig('tmp_file') || '/tmp/backup'
      return "#{filename}.gz" if gzip?
      filename
    end

    def execute
      begin
        # Perform DB dump & storage of backup with time measurements
        @ticks = [Time.now]
        res = @db.dump(tmp_file: tmp_file, gzip: gzip?)
        puts "RESSSS: #{res.inspect}"
        @ticks << Time.now
        @storage.persist(tmp_file: tmp_file, gzip: gzip?)
      rescue Exception => e
        @notifiers.each do |notifier|
          notifier.error(e.message, metadata)
        end
        puts "EXCEPTION RAISED: #{e.inspect}"
      else
        @notifiers.each do |notifier|
          notifier.success(metadata)
        end
        puts "SUCCESS"
      end

      File.delete(tmp_file) if File.exist?(tmp_file)
    end

    def metadata
      @ticks << Time.now
      data = []

      # Total backup size
      if File.exist?(tmp_file)
        compressed_file_size = File.size(tmp_file).to_f / 2**20
        formatted_file_size = '%.2f' % compressed_file_size
        data << "Total backup size: #{formatted_file_size} MB"
      else
        data << "No backup file was created"
      end

      # Backup time measurements
      if @ticks.count >= 2
        time_diff = duration_format(@ticks[1] - @ticks[0])
        data << "Backup dump duration: #{time_diff}"
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
        'options' => {
          'gzip' => false,
          'tmp_file' => '/tmp/backup'
        },
        'db' => {
          'type' => 'postgres',
          'options' => {
            'host' => 'ec2-00-00-100-100.eu-west-1.compute.amazonaws.com',
            'port' => 5432,
            'user' => 'username',
            'password' => 'password',
            'db' => 'databasename'
          }
        },
        'storage' => {
          'type' => 'local',
          'options' => {
            'filename' => 'backup.sql'
          }
        },
        'notifiers' => [
          {
            'type' => 'email',
            'options' => {
              'from' => 'backups@example.com',
              'to' => 'dba@example.com',
              'cc' => 'ops@example.com',
              'address' => 'smtp.yourserver.com',
              'port' => 25,
              'user_name' => 'user',
              'password' => 'password',
              'authentication' => 'plain'
            }
          },
          {
            'type' => 'slack',
            'options' => {
              'url' => 'https://slack.com/alksmdlakmsla'
            }
          }
        ]
      }
    end
  end
end
