module Martilla
  class Local < Storage
    def persist(tmp_file:, gzip:)
      bash("mv #{tmp_file} #{output_filename(gzip)}")
      return nil if $?.success?
      raise Error.new("Local storage failed with code #{$?.exitstatus}")
    end
  end
end
