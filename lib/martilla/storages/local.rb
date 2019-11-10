module Martilla
  class Local < Storage
    def persist(tmp_file:, gzip:)
      bash("mv #{tmp_file} #{output_filename(gzip)}")
      return nil if $?.success?
      raise Error.new("Local storage failed with code #{$?.exitstatus}")
    end

    def enfore_retention!(gzip:)
      return if retention_limit < 1
      files = backup_file_list(output_filename(gzip))

      while files.count > retention_limit do
        File.delete(files.first)
        puts "Retention limit met. Removed the backup file: #{files.shift}"
      end
    end

    private

    # Oldest first & most recent last
    def backup_file_list(sample_filename)
      dirname = File.dirname(sample_filename)
      basename = File.basename(sample_filename, '.*')

      if suffix?
        # Replaces file's basename timestamp for wildcards to match againts
        # what exist in the directory. Ex: "backup_2019-11-10T114342" will be
        # replaced with "backup_*-*-*T*". This means all backups will match
        # using `Dir.glob` below
        sections = basename.split('_').reject { |str| timestamp_regex =~ str }
        basename = "#{sections.join('_')}_*-*-*T*"
      end

      Dir["#{dirname}/#{basename}.*"].sort_by { |f| File.mtime(f) }
    end
  end
end
