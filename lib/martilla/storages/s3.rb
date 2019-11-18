require 'aws-sdk-s3'

module Martilla
  class S3 < Storage
    def persist(tmp_file:, gzip:)
      path = output_filename(gzip)
      # Files in the root path of a bucket need to be stripped of './'
      # See https://github.com/fdoxyz/martilla/issues/17
      path.slice!(0, 2) if path[0...2] == './'

      obj = s3_resource.bucket(bucket_name).object(path)
      return nil if obj.upload_file(tmp_file)
      raise Error.new('Error uploading backup to bucket')
    end

    def enfore_retention!(gzip:)
      return if retention_limit < 1

      objs = bucket_objs_for_retention(output_file: output_filename(gzip))
      while objs.count > retention_limit do
        delete_params = { bucket: bucket_name, key: objs.first.key }
        s3_resource.client.delete_object(delete_params)
        puts "Retention limit met. Removed the backup file: #{objs.shift.key}"
      end
    end

    private

    # Returns array of objs in the bucket that match the backup output file
    # format, ordered by `last_modified` where oldest is first and newest last
    def bucket_objs_for_retention(output_file:)
      res = s3_resource.client.list_objects({ bucket: bucket_name })
      objs = res.contents.sort_by(&:last_modified)

      # Path & File basename to check against to enforce retention restriction
      path = File.dirname(output_file)
      base_name = File.basename(output_file)

      if suffix?
        # When using a suffix make sure we replace the actual timestamp for a
        # regexp, otherwise because of different timestamps they'll never match
        index = base_name =~ timestamp_regex
        base_name.slice!(timestamp_regex)
        base_name.insert(index, "\\d{4}-\\d{2}-\\d{2}T\\d{6}")
      end

      # Rejects objects that don't match the directory location or if they don't
      # match with the same file basename structure
      objs.reject do |obj|
        directory_mismatch = File.dirname(obj.key) != path
        filename_mismatch = !(File.basename(obj.key) =~ /#{base_name}/)

        directory_mismatch || filename_mismatch
      end
    end

    def s3_resource
      options = {}
      options[:region] = aws_region unless aws_region.nil?
      options[:access_key_id] = aws_access_key unless aws_access_key.nil?
      options[:secret_access_key] = aws_secret_key unless aws_secret_key.nil?
      Aws::S3::Resource.new(options)
    end

    def aws_region
      @options['region']
    end

    def aws_access_key
      @options['access_key_id']
    end

    def aws_secret_key
      @options['secret_access_key']
    end

    def bucket_name
      bucket = @options['bucket']
      raise config_error('bucket') if bucket.nil?
      bucket
    end
  end
end
