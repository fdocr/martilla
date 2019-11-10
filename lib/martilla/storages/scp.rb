module Martilla
  class Scp < Storage
    def persist(tmp_file:, gzip:)
      `scp -i #{identity_file} #{user}@#{host}:#{output_filename(gzip)}`
      return nil if $?.success?
      raise Error.new("SCP storage failed with code #{$?.exitstatus}")
    end

    def enfore_retention!(gzip:)
      puts 'WARNING: Retention is not implemented for SCP storage. More details: https://github.com/fdoxyz/martilla/issues/12'
    end

    private

    def host
      scp_host = @options['host']
      raise config_error('host') if scp_host.nil?
      scp_host
    end

    def user
      scp_user = @options['user']
      raise config_error('user') if scp_user.nil?
      scp_user
    end

    def identity_file
      file = @options['identity_file']
      raise config_error('identity_file') if file.nil?
      file
    end
  end
end
