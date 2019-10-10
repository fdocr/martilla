require 'martilla/version'
require 'martilla/cli'

module Martilla
  class Error < StandardError; end

  def execute_backup(config)
    puts "EXECUTING BACKUP WITH CONFIG: #{config}"
    db = Database.new(config['db'])
    storage = Storage.new(config['storage'])
    notifiers = config['notifiers'].map { |c| Notifier.new(c) }

    begin
      # Perform DB dump & storage of backup
      temp_filepath = db.dump
      storage.persist(temp_filepath)
    rescue Exception => e
      puts "EXCEPTION RAISED: #{e.inspect}"
      notifiers.each do |notifier|
        notifier.error(e)
      end
    else
      puts "SUCCESS"
      notifiers.each do |notifier|
        notifier.success
      end
    end

    File.delete(temp_filepath) if File.exist?(temp_filepath)
  end
end
