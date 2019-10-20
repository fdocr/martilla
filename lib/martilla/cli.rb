require 'yaml'
require 'thor'

module Martilla
  class CLI < Thor
    desc "backup FILEPATH", "Generates a backup based on a config file located at FILEPATH"
    def backup(filepath)
      file_path = File.join(Dir.pwd, filepath)
      begin
        backup_config = YAML.load_file(file_path)
      rescue Psych::SyntaxError
        puts "Invalid yaml-file found, at #{file_path}"
      rescue Errno::EACCES
        puts "Couldn't access file due to permissions at #{file_path}"
      rescue Errno::ENOENT
        puts "Couldn't access non-existent file #{file_path}"
      else
        backup = Backup.create(backup_config)
      end
    end

    desc "setup FILEPATH", "Generates a sample backup config file at FILEPATH"
    def setup(filename = 'martilla.yml')
      file_path = File.join(Dir.pwd, filename)
      File.write(file_path, Backup.sample_config.to_yaml)
    end

    desc "version", "Prints out the current version"
    def version
      puts VERSION
    end
  end
end
